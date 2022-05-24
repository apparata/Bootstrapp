//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import BootstrappKit

private extension HorizontalAlignment {
    private enum FormFieldAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.trailing]
        }
    }
    static let formFieldAlignmentGuide = HorizontalAlignment(FormFieldAlignment.self)
}

struct TemplateParametersForm: View {
    
    let template: BootstrappTemplate
    
    // Kludge workaround for animation bug in macOS SwiftUI
    @State var okToAnimate: Bool = false
    
    @ObservedObject var parameterStore: ParameterStore
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Parameters").font(.subheadline).bold()
            VStack(alignment: .formFieldAlignmentGuide) {
                ForEach($parameterStore.parameters) { $parameter in
                    
                    HStack {
                        Text(parameter.parameter.name)
                            .alignmentGuide(.formFieldAlignmentGuide) { d in d[.trailing] }
                        if parameter.parameter.type == .string {
                            TextField(
                                "\(parameter.parameter.type.rawValue) (\(parameter.parameter.validationRegex?.pattern ?? ".*"))",
                                text: $parameter.value.stringValue,
                                onCommit: { print("Commit!") })
                                .border(SeparatorShapeStyle(), width: 2)
                                .frame(width: 300)
                            if okToAnimate {
                                CheckmarkView(isChecked: isParameterValid(parameter.parameter,
                                              input: parameter.value.stringValue))
                                    .frame(width: 10, height: 10)
                                    .padding(.leading, 2)
                            }
                            
                        } else if parameter.parameter.type == .bool {
                            Toggle("", isOn: $parameter.value.boolValue)
                                .foregroundColor(Color(NSColor.secondaryLabelColor))
                                .toggleStyle(CheckboxToggleStyle())
                            
                        } else if parameter.parameter.type == .option {
                            Picker(selection: $parameter.value.optionValue, label: EmptyView()) {
                                ForEach(0 ..< parameter.parameter.options.count, id: \.self) {
                                    Text(parameter.parameter.options[$0])
                                }
                            }.pickerStyle(PopUpButtonPickerStyle())
                                .frame(width: 300)
                        }
                    }.onAppear {
                        okToAnimate = true
                    }

                }
            }.padding(.leading, 30)
        }
    }
    
    private func isParameterValid(_ parameter: BootstrappParameter, input: String) -> Bool {
        parameter.validationRegex?.isMatch(input) ?? true
    }
}

struct CheckmarkView: View {
    
    var isChecked: Bool
    
    var body: some View {
        ValidatedShape()
            .offset(x: 0, y: 0)
            .trim(from: 0, to: isChecked ? 1 : 0)
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .foregroundColor(Color.green)
            .animation(Animation.easeInOut(duration: 0.5), value: isChecked)
    }
}

struct ValidatedShape: Shape {
    
    func path(in rect: CGRect) -> SwiftUI.Path {
        var path = SwiftUI.Path()
        path.move(to: CGPoint(x: 0, y: 0.6 * rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.35, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        return path
    }
}
