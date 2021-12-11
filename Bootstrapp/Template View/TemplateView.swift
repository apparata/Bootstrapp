//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import BootstrappKit
import Markin

struct TemplateView: View {
    
    let templateModel: TemplateModel
    
    var template: BootstrappTemplate {
        templateModel.template
    }
    
    @ObservedObject var parameterStore: ParameterStore
    
    @State private var showingInvalidInputSheet: Bool = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(template: TemplateModel) {
        templateModel = template
        parameterStore = ParameterStore(specification: templateModel.specification)
    }
    
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
        .toolbar {
            ToolbarItem {
                Button {
                    makeAction()
                } label: {
                    Image(systemName: "hammer.fill")
                }
            }
        }
        .navigationSubtitle(templateModel.id)
    }

    private func makeAction() {
        if validateParameters(parameterStore) {
            showingInvalidInputSheet = false
            bootstrapp(template: template, parameterStore: parameterStore)
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
    
    func bootstrapp(template: BootstrappTemplate, parameterStore: ParameterStore) {
        
        DispatchQueue.global().async {
            
            var parametersWithValues: [BootstrappParameter] = []
            for entry in parameterStore.parameters {
                switch entry.parameter.type {
                case .string:
                    let parameterWithValue = entry.parameter.withValue(value: entry.value.stringValue)
                    parametersWithValues.append(parameterWithValue)
                case .bool:
                    let parameterWithValue = entry.parameter.withValue(value: entry.value.boolValue)
                    parametersWithValues.append(parameterWithValue)
                case .option:
                    let parameterWithValue = entry.parameter.withValue(value: entry.value.optionValue)
                    parametersWithValues.append(parameterWithValue)
                }
            }
            
            let bootstrapp = Bootstrapp(template: template, parameters: parametersWithValues)
            do {
                let outputPath = try bootstrapp.instantiateTemplate()
                DispatchQueue.main.async {
                    NSWorkspace.shared.open(outputPath.url)
                }
            } catch {
                dump(error)
                return
            }
            
        }
    }
}

struct ParameterValue {
    var stringValue: String
    var boolValue: Bool
    var optionValue: Int
    init(stringValue: String = "", boolValue: Bool = false, optionValue: Int = 0) {
        self.stringValue = stringValue
        self.boolValue = boolValue
        self.optionValue = 0
    }
}

struct ParameterAndValue {

    let parameter: BootstrappParameter
    var value: ParameterValue
}

class ParameterStore: ObservableObject {
    
    @Published var parameters: [ParameterAndValue]
    
    init(specification: BootstrappSpecification) {
        var parameters: [ParameterAndValue] = []
        for parameter in specification.parameters {
            switch parameter.type {
            case .string:
                parameters.append(ParameterAndValue(parameter: parameter, value: ParameterValue(stringValue: parameter.defaultStringValue)))
            case .bool:
                parameters.append(ParameterAndValue(parameter: parameter, value: ParameterValue(boolValue: parameter.defaultBoolValue)))
            case .option:
                parameters.append(ParameterAndValue(parameter: parameter, value: ParameterValue(optionValue: parameter.defaultOptionValue)))
            }
        }
        self.parameters = parameters
    }
}
