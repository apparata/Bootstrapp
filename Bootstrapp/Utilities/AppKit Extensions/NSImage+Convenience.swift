//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Cocoa

public extension NSImage {
    
    convenience init(requiredNamed name: String) {
        self.init(named: name)!
    }
}
