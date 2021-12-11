//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI

struct InvalidInputSheet: View {
    
    @Binding var showingSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Invalid input")
                .font(.headline)
            Text("Please double-check that the parameter fields are valid.")
                .padding(.top, 16)
            HStack {
                Spacer()
                MacButton(title: "OK", keyEquivalent: .carriageReturn) {
                    showingSheet = false
                }
            }
            .padding(.top, 14)
        }
        .padding(EdgeInsets(top: 26, leading: 26, bottom: 16, trailing: 26))
    }
}
