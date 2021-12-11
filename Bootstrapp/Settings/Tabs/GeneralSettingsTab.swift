//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import SwiftUI

struct GeneralSettingsTab: View {
    
    @AppStorage("serviceSuffix") private var serviceSuffix: String = ""
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    TextField("Placeholder", text: $serviceSuffix, onCommit: {
                        // Do stuff
                    })
                }
            }
            Divider()
            Form {
                HStack {
                    TextField("Placeholder", text: $serviceSuffix, onCommit: {
                        // Do stuff
                    })
                }
            }
        }
        .padding(20)
        //.frame(width: 350, height: 100)
    }
}

struct GeneralSettingsTab_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsTab()
    }
}
