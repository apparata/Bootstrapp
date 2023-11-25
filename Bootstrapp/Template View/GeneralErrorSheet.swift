//
//  Copyright © 2023 Apparata AB. All rights reserved.
//

import SwiftUI

struct GeneralErrorSheet: View {

    let errorText: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            Text("Error")
                .font(.headline)
            Text(errorText)
                .padding(.top, 16)
            HStack {
                Spacer()
                MacButton(title: "OK", keyEquivalent: .carriageReturn) {
                    dismiss()
                }
            }
            .padding(.top, 14)
        }
        .padding(EdgeInsets(top: 26, leading: 26, bottom: 16, trailing: 26))
    }
}
