//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import SwiftUI

@main
struct BootstrappApp: App {

    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
            
    @StateObject var templates = TemplatesModel()

    var body: some Scene {
        
        WindowGroup {
            MainView()
                .frame(minWidth: 900, minHeight: 500)
                .edgesIgnoringSafeArea(.all)
                .coordinateSpace(name: "HoverSpace")
                .environmentObject(MainWindowState())
                .environmentObject(templates)
        }
        .commands {
            SidebarCommands()
            TemplateCommands(templates: templates)
            AboutCommand {
                appDelegate.showAboutWindow()
            }

            // Remove the "New Window" option from the File menu.
            CommandGroup(replacing: .newItem, addition: { })
        }
        
        Settings {
            SettingsView()
        }
    }
}

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Stop any stuff that needs to be stopped.
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func showAboutWindow() {
        AboutWindowController().window?.makeKeyAndOrderFront(nil)
    }
    
    /// Show settings programmatically
    func showSettings() {
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
    }
}
