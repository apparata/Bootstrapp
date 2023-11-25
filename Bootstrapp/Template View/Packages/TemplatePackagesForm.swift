//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import AppKit
import BootstrappKit

struct TemplatePackagesForm: View {
    
    let template: BootstrappTemplate
        
    @ObservedObject var packageStore: PackageStore
    
    @State private var showingAddPackageSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Packages")
                .font(.subheadline)
                .bold()
            
            VStack {
                Grid {
                    ForEach($packageStore.packages) { $package in
                        GridRow {
                            Link(package.name, destination: URL(string: package.url) ?? URL(string: "https://github.com")!)
                            //.alignmentGuide(.formFieldAlignmentGuide) { d in d[.trailing] }
                                .foregroundColor(.primary)
                                .onContinuousHover { phase in
                                    if #available(macOS 13.0, *) {
                                        switch phase {
                                        case .active:
                                            NSCursor.pointingHand.set()
                                        case .ended:
                                            NSCursor.arrow.set()
                                        }
                                    }
                                }
                                .gridColumnAlignment(.trailing)
                            TextField(
                                "",
                                text: $package.url,
                                onCommit: { /*print("Commit!")*/ })
                                .border(SeparatorShapeStyle(), width: 2)
                                .frame(width: 340)
                                .gridColumnAlignment(.leading)
                            TextField(
                                "",
                                text: $package.version,
                                onCommit: { /*print("Commit!")*/ })
                                .border(SeparatorShapeStyle(), width: 2)
                                .frame(width: 60)
                                .gridColumnAlignment(.leading)
                            Button {
                                packageStore.removePackage(id: package.id)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    GridRow {
                        Text("")
                        
                        Button {
                            showingAddPackageSheet = true
                        } label: {
                            Label("Add Package", systemImage: "plus")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                        .sheet(isPresented: $showingAddPackageSheet) {
                            AddPackageSheet(showingSheet: $showingAddPackageSheet, packageStore: packageStore)
                        }
                    }
                }
                
            }.padding(.leading, 30)
        }
    }
}
