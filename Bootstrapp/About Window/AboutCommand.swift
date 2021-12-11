//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import SwiftUI

struct AboutCommand: Commands {
    
    var aboutAction: () -> Void
    
    var body: some Commands {
        // Replace the About window menu option.
        CommandGroup(replacing: CommandGroupPlacement.appInfo) {
            Button {
                aboutAction()
            } label: {
                Text("About \(Bundle.main.name)")
            }
        }
    }
}
