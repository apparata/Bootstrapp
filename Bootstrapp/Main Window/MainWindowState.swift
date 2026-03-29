//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SwiftUI
import Observation

@Observable
class MainWindowState {

    var isHoveringOverDropZone: Bool = false

    var hoverLocation: CGPoint = .zero

    let hoverSpace: CoordinateSpace = .named("HoverSpace")

    init() {
    }
}
