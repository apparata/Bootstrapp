//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI

struct MainContentView<Content>: View where Content: View {

    let content: Content

    private let backgroundColor: Color

    @inlinable
    init(backgroundColor: Color = Color(NSColor.controlBackgroundColor), @ViewBuilder content: () -> Content) {
        self.content = content()
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.top)
            content
        }.edgesIgnoringSafeArea(.top)
    }
}
