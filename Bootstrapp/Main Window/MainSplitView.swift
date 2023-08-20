//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import BootstrappKit
import Combine
import SwiftUIToolbox

struct MainSplitView: View {
    
    @ObservedObject private var searchFilter = SearchFilter<TemplateModel>()
    
    @EnvironmentObject private var templatesViewModel: TemplatesModel
    
    @EnvironmentObject var windowState: MainWindowState
        
    init() {
        //
    }
    
    var body: some View {
        NavigationSplitView {
            
            List(selection: $templatesViewModel.templateSelection) {
                
                ForEach(templatesViewModel.templatesByCategory.keys.sorted(), id: \.self) { category in
                    Section(header: Text(category)) {
                        ForEach(searchFilter.apply(to: templatesViewModel.templates(by: category))) { template in
                            NavigationLink(value: template) {
                                Image(template.icon)
                                    .shadow(radius: 1, x: 0, y: 1)
                                Text(template.id)
                                    .font(Font.system(size: 12))
                                    .fixedSize()
                                    .offset(x: -3, y: 0)
                            }
                        }
                    }
                }
                
            }
            .listStyle(SidebarListStyle())
            .safeAreaInset(edge: .bottom, spacing: 0) {
                WindowAlwaysOnTopSidebarToggle()
            }
            .frame(minWidth: 180, idealWidth: 250)
            .layoutPriority(2)
            .searchable(text: $searchFilter.searchText, placement: .sidebar) /*{
                // Suggestions go here
                Text("Banarne")
                    .searchCompletion("Banarne")
            }*/
            .navigationTitle("Bootstrapp")
            
        } detail: {
            if let template = templatesViewModel.templateSelection {
                ZStack {
                    TemplateView(
                        templateModel: template,
                        parameterStore: template.parameterStore,
                        packageStore: template.packageStore)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                NoTemplatesView()
            }
        }
    }
}
