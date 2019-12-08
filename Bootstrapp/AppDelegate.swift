//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var mainWindowController: MainWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindowController = MainWindowController()
        mainWindowController?.window?.makeKeyAndOrderFront(nil)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func showAboutWindow(_ sender: AnyObject?) {
        AboutWindowController().window?.makeKeyAndOrderFront(nil)
    }
}
