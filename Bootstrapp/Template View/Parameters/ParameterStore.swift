//
//  Copyright © 2023 Apparata AB. All rights reserved.
//

import SwiftUI
import BootstrappKit

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

struct ParameterAndValue: Identifiable {
    var id: String { parameter.id }
    let parameter: BootstrappParameter
    var value: ParameterValue
}

class ParameterStore: ObservableObject {
    
    @Published var parameters: [ParameterAndValue]
    
    private let originalParameters: [ParameterAndValue]
    
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
        self.originalParameters = parameters
    }
    
    func reset() {
        parameters = originalParameters
    }
}
