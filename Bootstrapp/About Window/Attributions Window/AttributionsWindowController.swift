//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Cocoa
import SwiftUI
import Markin

class AttributionsWindowController: NSWindowController {

    convenience init() {
        
        let window = Self.makeWindow()
                
        window.backgroundColor = NSColor.controlBackgroundColor
                
        self.init(window: window)

        let contentView = makeAttributionsView()
            .frame(minWidth: 500, minHeight: 300)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.center()
        window.title = "About Bootstrapp"
        window.contentView = NSHostingView(rootView: contentView)
        window.alwaysOnTop = true
    }
    
    private static func makeWindow() -> NSWindow {
        let contentRect = NSRect(x: 0, y: 0, width: 500, height: 300)
        let styleMask: NSWindow.StyleMask = [
            .titled,
            .miniaturizable,
            .resizable,
            .closable,
            .fullSizeContentView
        ]
        return NSWindow(contentRect: contentRect,
                        styleMask: styleMask,
                        backing: .buffered,
                        defer: false)
    }

    private func makeAttributionsView() -> some View {
        let url = Bundle.main.url(forResource: "ATTRIBUTIONS", withExtension: nil)
        let content = try! String(contentsOf: url!)
        let document = try! MarkinParser().parse(content)
        return ScrollView(.vertical) {
            MarkinDocumentView(element: document, style: MarkinStyle())
                .padding()
                .padding(.leading, 20)
                .padding(.trailing, 20)
        }.padding(.top, 1)
    }
}
