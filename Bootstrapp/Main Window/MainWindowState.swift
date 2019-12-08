//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import BootstrappKit

class MainWindowState: ObservableObject {
    
    private weak var window: NSWindow?
    
    @Published var alwaysOnTop: Bool = UserDefaults.standard.bool(forKey: "Setting_AlwaysOnTop")

    @Published var isHoveringOverDropZone: Bool = false
    
    @Published var hoverLocation: CGPoint = .zero
    
    let hoverSpace: CoordinateSpace = .named("HoverSpace")
    
    var currentTemplate: BootstrappTemplate?
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init(window: NSWindow) {
        self.window = window
        $alwaysOnTop
            .sink { [weak self] in
                UserDefaults.standard.set($0, forKey: "Setting_AlwaysOnTop")
                self?.window?.alwaysOnTop = $0
            }
            .store(in: &cancellables)
    }
}
