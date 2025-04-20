//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import BootstrappKit
import Markin

struct ErrorText: Identifiable {
    var id: String { text }
    let text: String
}

extension Notification.Name {
    static let bootstrappCurrentTemplate = Notification.Name("bootstrappCurrentTemplate")
}

struct TemplateView: View {
    
    let templateModel: TemplateModel

    @ObservedObject var parameterStore: ParameterStore
    @ObservedObject var packageStore: PackageStore
    
    var template: BootstrappTemplate {
        templateModel.template
    }
    
    @State private var showingInvalidInputSheet: Bool = false

    @State private var openIn: OpenIn = .finder
    
    @State private var errorText: ErrorText?

    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            Color(NSColor.controlBackgroundColor)
                .edgesIgnoringSafeArea(.top)
            ScrollView {
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading) {
                        Text(template.id)
                            .font(.title)
                            .bold()
                        Divider()
                            .padding(.top, -10)
                        Text(template.specification.description)
                            .font(.system(size: 14))
                            .padding(.top, 2)
                            .padding(.bottom, 12)
                            .lineSpacing(2)
                    }.padding(EdgeInsets(top: 20, leading: 40, bottom: 0, trailing: 40))

                    TemplatePreview(template: template)
                        .padding(.top, 6)
                        .padding(.bottom, 6)

                    VStack(alignment: .leading) {
                                                
                        TemplateParametersForm(template: template, parameterStore: parameterStore)
                            .padding(.bottom, 16)
                        
                        Divider()
                            .padding(.bottom, 16)
                        
                        if !packageStore.packages.isEmpty {
                            TemplatePackagesForm(template: template, packageStore: packageStore)
                                .padding(.bottom, 16)
                            
                            Divider()
                                .padding(.bottom, 16)
                        }
                        
                        template.document.map {
                            return MarkinDocumentView(element: $0, style: makeMarkinStyle(codeTheme: colorScheme == .dark ? .bootstrappDark() : .bootstrappLight()))
                        }
                        
                    }.padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 40, trailing: 0))
            }.padding(.top, 1)
        }
        .sheet(isPresented: $showingInvalidInputSheet) {
            InvalidInputSheet(showingSheet: $showingInvalidInputSheet)
        }
        .sheet(item: $errorText) { errorText in
            GeneralErrorSheet(errorText: errorText.text)
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    withAnimation {
                        parameterStore.reset()
                        packageStore.reset()
                    }
                } label: {
                    Label("Reset", systemImage: "trash")
                }
                .help("Reset Form")
                
                Spacer()
                Spacer()

                if case .xcodeProject = template.specification.type {
                    Picker("", selection: $openIn) {
                        Text("Open in Finder").tag(OpenIn.finder)
                        Text("Open in Xcode").tag(OpenIn.Xcode)
                    }
                    .labelsHidden()
                }
                Button {
                    makeAction()
                } label: {
                    Label("Generate", systemImage: "hammer.fill")
                }
                .help("Generate")
            }
        }
        .navigationSubtitle(templateModel.id)
        .onReceive(NotificationCenter.default.publisher(for: .bootstrappCurrentTemplate)) { _ in
            DispatchQueue.main.async {
                makeAction()
            }
        }
    }

    private func makeAction() {
        if validateParameters(parameterStore) {
            showingInvalidInputSheet = false
            Task.detached {
                do {
                    try await Bootstrapper().bootstrapp(
                        template: template,
                        parameterStore: parameterStore,
                        packageStore: packageStore,
                        openIn: openIn)
                } catch {
                    await MainActor.run {
                        dump(error)
                        var string: String = ""
                        dump(error, to: &string)
                        self.errorText = ErrorText(text: string)
                    }
                }
            }
        } else {
            showingInvalidInputSheet = true
        }
    }
}

private extension TemplateView {
    
    func validateParameters(_ parameterStore: ParameterStore) -> Bool {
        for entry in parameterStore.parameters {
            if entry.parameter.type == .string {
                
                if let dependsOnParameterID = entry.parameter.dependsOnParameter {
                    if let matchingParameter = parameterStore.parameters.first(where: {
                        $0.parameter.id == dependsOnParameterID
                    }) {
                        if matchingParameter.value.boolValue == false && matchingParameter.value.stringValue.isEmpty {
                            continue
                        }
                    }
                }
                
                guard entry.parameter.validationRegex?.isMatch(entry.value.stringValue) ?? true else {
                    return false
                }
            }
        }
        
        return true
    }    
}
