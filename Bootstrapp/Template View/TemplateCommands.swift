//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import SwiftUI

struct TemplateCommands: Commands {
    
    @FocusedObject var templates: TemplatesModel?

    var body: some Commands {
        CommandMenu(Text("Templates", comment: "Menu title for template actions")) {
            Button {
                NotificationCenter.default.post(name: .bootstrappCurrentTemplate, object: nil)
            } label: {
                Text("Build", comment: "Build the selected template.")
            }
            .keyboardShortcut("B", modifiers: [.command])
            .disabled(templates?.templateSelection == nil)
            
            Divider()
            
            Button {
                withAnimation {
                    templates?.unsetTemplateRootFolder()
                }
            } label: {
                Text("Close Template Root Folder", comment: "Close all templates.")
            }
            .keyboardShortcut("K", modifiers: [.command])
        }
    }
}
