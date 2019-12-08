//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Cocoa
import SwiftUI
import BootstrappKit

class MainWindowController: NSWindowController, NSToolbarDelegate {

    private var toolbar: NSToolbar!
            
    private var windowState: MainWindowState!
    
    private let templates = Templates()

    convenience init() {
        
        let window = Self.makeWindow()
                
        window.backgroundColor = NSColor.controlBackgroundColor
                
        self.init(window: window)

        windowState = MainWindowState(window: window)

        let contentView = makeMainView(templates: templates)
            .environmentObject(windowState)
            .environmentObject(TemplatesViewModel(templates: templates))
            
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.center()
        window.title = "Bootstrapp"
        window.contentView = NSHostingView(rootView: contentView)
        window.setFrameAutosaveName("MainAppWindow")
        window.alwaysOnTop = windowState.alwaysOnTop
        
        toolbar = makeToolbar()
        toolbar.delegate = self
        window.toolbar = toolbar
    }
    
    private static func makeWindow() -> NSWindow {
        let contentRect = NSRect(x: 0, y: 0, width: 900, height: 500)
        let styleMask: NSWindow.StyleMask = [
            .titled,
            .closable,
            .miniaturizable,
            .resizable,
            .fullSizeContentView
        ]
        return NSWindow(contentRect: contentRect,
                        styleMask: styleMask,
                        backing: .buffered,
                        defer: false)
    }

    private func makeMainView(templates: Templates) -> some View {
        MainView(templates: templates, mainWindowState: windowState)
        .frame(minWidth: 900, minHeight: 500)
        .edgesIgnoringSafeArea(.all)
        .coordinateSpace(name: "HoverSpace")

    }
    
    private func makeToolbar() -> NSToolbar {
        toolbar = NSToolbar(identifier: "Bootstrapp.MainAppWindowToolbar")
        toolbar.allowsUserCustomization = false
        toolbar.autosavesConfiguration = false
        toolbar.showsBaselineSeparator = false
        toolbar.displayMode = .iconOnly
        return toolbar
    }
        
    @objc
    public func makeAction(_ sender: NSToolbarItem?) {
        NotificationCenter.default.post(name: .toolbarMakeAction, object: nil)
    }
    
    // MARK: - NSToolbarDelegate
    
    public func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem
        
        switch itemIdentifier {
        case .makeItem:
            toolbarItem = NSToolbarItem(id: .makeItem,
                                        target: self,
                                        selector: #selector(makeAction(_:)),
                                        label: "MAKE",
                                        image: NSImage(requiredNamed: "hammer"),
                                        toolTip: "Make")
        case NSToolbarItem.Identifier.flexibleSpace:
            toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        default:
            fatalError()
        }
        
        return toolbarItem
    }
    
    public func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .flexibleSpace,
            .makeItem
        ]
    }
    
    public func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .flexibleSpace,
            .flexibleSpace,
            .makeItem
        ]
    }
}

extension NSToolbarItem.Identifier {
    static let makeItem = NSToolbarItem.Identifier("make")
}

extension Notification.Name {
    static let toolbarMakeAction = Self("toolbarMakeActionNotification")
}
