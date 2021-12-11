//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

extension Bundle {
    
    var version: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    }
    
    var buildVersion: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    }
}
