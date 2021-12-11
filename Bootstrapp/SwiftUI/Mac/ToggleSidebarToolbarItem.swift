//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import SwiftUI
import AppKit

public struct ToggleSidebarToolbarItem: ToolbarContent {
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button(action: toggleSidebar, label: {
                Image(systemName: "sidebar.leading")
            })
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
