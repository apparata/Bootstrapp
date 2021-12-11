//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import SwiftUI

@main
struct BootstrappApp: App {

    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var windowState = MainWindowState(window: nil)
    
    @StateObject var templates = Templates()

    var body: some Scene {
        WindowGroup {
            MainView(templates: templates, mainWindowState: windowState)
                .frame(minWidth: 900, minHeight: 500)
                .edgesIgnoringSafeArea(.all)
                .coordinateSpace(name: "HoverSpace")
                .environmentObject(windowState)
                .environmentObject(TemplatesViewModel(templates: templates))
        }
    }
}

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    #warning("What about the About window?")
    //@IBAction func showAboutWindow(_ sender: AnyObject?) {
    //    AboutWindowController().window?.makeKeyAndOrderFront(nil)
    //}
}
