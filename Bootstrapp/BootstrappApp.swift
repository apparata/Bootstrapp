//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import SwiftUI
import SwiftUIToolbox
import AttributionsUI

// MARK: - Bootstrapp App

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
                .focusedSceneObject(templates)
        }
        .commands {
            SidebarCommands()
            TemplateCommands()
            AboutCommand()
            HelpCommands()

            // Remove the "New Window" option from the File menu.
            CommandGroup(replacing: .newItem, addition: { })
        }
        
        SettingsWindow()
        
        AboutWindow(developedBy: "Martin Johannesson",
                    attributionsWindowID: AttributionsWindow.windowID)
        
        AttributionsWindow(
            "Bootstrapp may contain the following Third-Party packages:",
            ("Splash", .mit(year: "2018", holder: "John Sundell")),
            ("XcodeGen", .mit(year: "2018", holder: "Yonas Kolb")),
            ("AEXML", .mit(year: "2014-2019", holder: "Marko Tadić <tadija@me.com> http://tadija.net")),
            ("Graphviz", .mit(year: "2020", holder: "Read Evaluate Press, LLC")),
            ("JSONUtilities", .mit(year: "2016", holder: "Luciano Marisi")),
            ("PathKit", .bsd2Clause(year: "2014", holder: "Kyle Fuller. All rights reserved.")),
            ("Rainbow", .mit(year: "2015", holder: "Wei Wang")),
            ("Spectre", .bsd2Clause(year: "2015", holder: "Kyle Fuller. All rights reserved.")),
            ("SwiftCLI", .mit(year: "2014", holder: "Jake Heiser")),
            ("Version", .apache2(year: "2021", holder: "Max Howell")),
            ("Xcodeproj", .mit(year: "2018", holder: "Pedro Piñera Buendía")),
            ("Yams", .mit(year: "2016", holder: "JP Simard"))
        )
        
        HelpWindow()
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
}
