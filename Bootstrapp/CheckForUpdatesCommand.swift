//
//  Copyright © 2024 Apparata AB. All rights reserved.
//

import SwiftUI
import SwiftUIToolbox
import Sparkle

struct AppInfoCommands: Commands {

    @Environment(\.openWindow) private var openWindow

    let updater: SPUUpdater

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button {
                openWindow(id: AboutWindow.windowID)
            } label: {
                Text("About \(Bundle.main.name)")
            }

            Button("Check for Updates…") {
                updater.checkForUpdates()
            }
            .disabled(!updater.canCheckForUpdates)
        }
    }
}
