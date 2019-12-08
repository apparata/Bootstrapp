//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import BootstrappKit
import Combine
import SwiftUIToolbox

struct MainSplitView: View {
    
    @ObservedObject private var searchFilter = SearchFilter<TemplateViewModel>()
    
    @EnvironmentObject private var templatesViewModel: TemplatesViewModel
    
    @EnvironmentObject var windowState: MainWindowState
    
    init() {
        //
    }
    
    var body: some View {
        NavigationView {
            
            MainSidebarView {
                
                SidebarSearchField(text: $searchFilter.searchText)
                    .padding(EdgeInsets(top: 16, leading: 10, bottom: 0, trailing: 10))
                
                List(selection: $templatesViewModel.templateSelection) {
                    ForEach(templatesViewModel.templatesByCategory.keys.sorted(), id: \.self) { category in
                        Section(header: Text(category)) {
                            ForEach(self.searchFilter.apply(to: self.templatesViewModel.templates(by: category))) { template in
                                NavigationLink(destination: ZStack {
                                        TemplateView(template: template)
                                    }
                                    .tag(template)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)) {
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
                
                Divider()
                
                Toggle("Always on top", isOn: $windowState.alwaysOnTop)
                    .foregroundColor(Color(NSColor.secondaryLabelColor))
                    .toggleStyle(CheckboxToggleStyle())
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
            }
            NoTemplatesView()
        }
    }
}
