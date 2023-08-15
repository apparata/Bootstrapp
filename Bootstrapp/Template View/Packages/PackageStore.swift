//
//  Copyright © 2023 Apparata AB. All rights reserved.
//

import SwiftUI
import BootstrappKit

struct PackageDependency: Identifiable {
    var id: String { name }
    let name: String
    var url: String
    var version: String
}

class PackageStore: ObservableObject {
    
    @Published var packages: [PackageDependency]
    
    private let originalPackages: [PackageDependency]
    
    init(specification: BootstrappSpecification) {
        var packages: [PackageDependency] = []
        for package in specification.packages {
            packages.append(PackageDependency(
                name: package.name,
                url: package.url,
                version: package.version))
        }
        self.packages = packages
        self.originalPackages = packages
    }
    
    func addPackage(_ package: PackageDependency) {
        withAnimation {
            packages.append(package)
        }
    }
    
    func removePackage(id: String) {
        withAnimation {
            packages.removeAll { package in
                package.id == id
            }
        }
    }
    
    func reset() {
        packages = originalPackages
    }
}
