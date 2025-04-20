//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import TemplateKit

struct AddPackageSheet: View {
    
    @Binding var showingSheet: Bool
    @ObservedObject var packageStore: PackageStore
    
    @State private var name: String = ""
    @State private var url: String = ""
    @State private var version: String = ""
        
    private var isValid: Bool {
        !(name.trimmed().isEmpty
        || url.trimmed().isEmpty
        || version.trimmed().isEmpty)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add Package")
                .font(.headline)
                .padding(.bottom)
            Form {
                TextField("Name", text: $name)
                    .frame(width: 200)
                TextField("Repository", text: $url)
                    .frame(width: 300)
                TextField("Version", text: $version)
                    .frame(width: 120)
            }
            HStack {
                Spacer()
                
                Button(role: .cancel) {
                    showingSheet = false
                } label: {
                    Text("Cancel")
                }
                
                MacButton(title: "OK", keyEquivalent: .carriageReturn) {
                    let package = PackageDependency(name: name, url: url, version: version)
                    packageStore.addPackage(package)
                    showingSheet = false
                }.disabled(!isValid)
            }
            .padding(.top, 14)
        }
        .padding(EdgeInsets(top: 26, leading: 26, bottom: 16, trailing: 26))
    }
}
