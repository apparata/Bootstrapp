//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import BootstrappKit

class MainWindowState: ObservableObject {
    
    @Published var isHoveringOverDropZone: Bool = false
    
    @Published var hoverLocation: CGPoint = .zero
    
    let hoverSpace: CoordinateSpace = .named("HoverSpace")
    
    var currentTemplate: BootstrappTemplate?
    
    init() {
    }
}
