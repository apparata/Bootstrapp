//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI

public struct MainSidebarView<Content>: View where Content: View {

    public let content: Content

    @inlinable
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .frame(minWidth: 180)
        .layoutPriority(2)
    }
}
