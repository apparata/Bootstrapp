//
//  Copyright © 2023 Apparata AB. All rights reserved.
//

import Foundation
import BootstrappKit
import AppKit

enum OpenIn: Identifiable {
    case finder
    case Xcode
    
    var id: Self { self }
}

class Bootstrapper {
    
    func bootstrapp(
        template: BootstrappTemplate,
        parameterStore: ParameterStore,
        packageStore: PackageStore,
        openIn: OpenIn
    ) async throws {

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

        var packages: [BootstrappPackage] = []
        for entry in packageStore.packages {
            packages.append(BootstrappPackage(
                name: entry.name,
                url: entry.url,
                version: entry.version))
        }

        let bootstrapp = Bootstrapp(
            template: template,
            parameters: parametersWithValues,
            packages: packages)

        var outputPath = try bootstrapp.instantiateTemplate()
        if openIn == .finder, outputPath.url.pathExtension == "xcodeproj" {
            outputPath = outputPath.deletingLastComponent
        }

        let url = outputPath.url
        await MainActor.run {
            _ = NSWorkspace.shared.open(url)
        }
    }
}
