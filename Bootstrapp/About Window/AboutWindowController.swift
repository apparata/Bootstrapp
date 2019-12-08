//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Cocoa
import SwiftUI

class AboutWindowController: NSWindowController {

    convenience init() {
        
        let window = Self.makeWindow()
                
        window.backgroundColor = NSColor.controlBackgroundColor
                
        self.init(window: window)

        let contentView = makeAboutView()
            
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.center()
        window.title = "About Bootstrapp"
        window.contentView = NSHostingView(rootView: contentView)
        window.alwaysOnTop = true
    }
    
    private static func makeWindow() -> NSWindow {
        let contentRect = NSRect(x: 0, y: 0, width: 500, height: 260)
        let styleMask: NSWindow.StyleMask = [
            .titled,
            .closable,
            .fullSizeContentView
        ]
        return NSWindow(contentRect: contentRect,
                        styleMask: styleMask,
                        backing: .buffered,
                        defer: false)
    }

    private func makeAboutView() -> some View {
        
        let icon = NSApp.applicationIconImage ?? NSImage()
        let info = Bundle.main.infoDictionary
        let name = info?["CFBundleName"] as? String ?? "Bootstrapp"
        let version = info?["CFBundleShortVersionString"] as? String ?? "?.?.?"
        let build = info?["CFBundleVersion"] as? String ?? "?"
        let copyright = info?["NSHumanReadableCopyright"] as? String ?? "Copyright © 2019 Apparata AB"
        
        return AboutView(icon: icon,
                         name: name,
                         version: version,
                         build: build,
                         copyright: copyright)
            .frame(width: 500, height: 260)
    }
}
