//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import SwiftUI

struct TemplateCommands: Commands {
    
    @ObservedObject var templates = TemplatesModel()

    var body: some Commands {
        CommandMenu(Text("Templates", comment: "Menu title for template actions")) {
            Button {
                print("Templates!")
            } label: {
                Text("Build", comment: "Build the selected template.")
            }
            .keyboardShortcut("B", modifiers: [.command])
            
            Divider()
            
            Button {
                templates.unsetTemplateRootFolder()
            } label: {
                Text("Close Template Root Folder", comment: "Close all templates.")
            }
            .keyboardShortcut("K", modifiers: [.command])
        }
    }
}
