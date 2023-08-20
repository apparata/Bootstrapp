//
//  Copyright © 2023 Apparata AB. All rights reserved.
//

import SwiftUI

struct HelpCommands: Commands {
    
    @Environment(\.openWindow) private var openWindow
            
    var body: some Commands {
        CommandGroup(replacing: .help) {
            Button {
                openWindow(id: HelpWindow.windowID)
            } label: {
                Text("\(Bundle.main.name) Help")
            }
        }
    }
}
