//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import SwiftUI
import AppKit

public struct WindowAccessor: NSViewRepresentable {
    
    @Binding var window: NSWindow?
    
    public func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window
        }
        return view
    }
    
    public func updateNSView(_ nsView: NSView, context: Context) {}
}
