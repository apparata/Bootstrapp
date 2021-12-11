//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import SwiftUI
import AppKit

public struct WindowAlwaysOnTopSidebarToggle: View {
    
    @AppStorage("setting_isAlwaysOnTop") private var isAlwaysOnTop: Bool = false
        
    @State private var window: NSWindow?
    
    public var body: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(maxHeight: 1)
            HStack {
                Toggle("Always on top", isOn: $isAlwaysOnTop)
                    .foregroundColor(Color(NSColor.secondaryLabelColor))
                    .toggleStyle(CheckboxToggleStyle())
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 8, trailing: 8))
                Spacer()
            }
        }
        .background(WindowAccessor(window: $window))
        .onReceive(window.publisher) { window in
            window.alwaysOnTop = isAlwaysOnTop
        }
        .onChange(of: isAlwaysOnTop) { isOnTop in
            window?.alwaysOnTop = isOnTop
        }
    }
}
