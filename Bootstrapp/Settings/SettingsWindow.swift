//
//  Copyright © 2023 Apparata AB. All rights reserved.
//

import SwiftUI

struct SettingsWindow: Scene {

    private enum Tabs: Hashable {
        case general
    }

    var body: some Scene {
        Settings {
            tabs
        }
    }
    
    @ViewBuilder var tabs: some View {
        TabView {
            GeneralSettingsTab()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
    
    /// Show settings programmatically
    static func show() {
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
    }
}
