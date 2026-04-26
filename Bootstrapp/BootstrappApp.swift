//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import SwiftUI
import SwiftUIToolbox
import AttributionsUI
import Sparkle

// MARK: - Bootstrapp App

@main
struct BootstrappApp: App {

    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State var templates = TemplatesModel()
    @State var mainWindowState = MainWindowState()

    private let updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )

    var body: some Scene {

        WindowGroup {
            MainView()
                .frame(minWidth: 900, minHeight: 500)
                .edgesIgnoringSafeArea(.all)
                .coordinateSpace(name: "HoverSpace")
                .environment(mainWindowState)
                .environment(templates)
                .focusedSceneValue(\.templatesModel, templates)
        }
        .commands {
            SidebarCommands()
            TemplateCommands()
            AppInfoCommands(updater: updaterController.updater)
            HelpCommands()

            // Remove the "New Window" option from the File menu.
            CommandGroup(replacing: .newItem, addition: { })
        }

        SettingsWindow()

        AboutWindow(developedBy: "Martin Johannesson",
                    attributionsWindowID: AttributionsWindow.windowID)

        AttributionsWindow(
            "Bootstrapp may contain the following Third-Party packages:",
            ("Sparkle", .mit(year: "2006-2017", holder: "Andy Matuschak et al.")),
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

    // Sparkle may show its update-permission prompt before the main window
    // appears. If that prompt is the only open window, closing it would
    // otherwise terminate the app before it has even started.
    static var shouldTerminateAppAfterLastWindowClosed = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Stop any stuff that needs to be stopped.
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        Self.shouldTerminateAppAfterLastWindowClosed
    }
}

// MARK: - View Modifier

extension View {

    /// Marks this view as the main window for the purposes of
    /// `applicationShouldTerminateAfterLastWindowClosed`. Once the view has
    /// appeared at least once, the app is allowed to terminate when the last
    /// window closes.
    func terminatesAppWhenClosed() -> some View {
        onAppear {
            AppDelegate.shouldTerminateAppAfterLastWindowClosed = true
        }
    }
}
