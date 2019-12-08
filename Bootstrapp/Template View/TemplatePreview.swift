//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftUIToolbox
import BootstrappKit

struct TemplatePreview: View {
    
    let template: BootstrappTemplate
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Preview")
                .font(.subheadline)
                .bold()
                .padding(.leading, 40)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 20) {
                    if template.previewImageFiles.isEmpty {
                        Placeholder(cornerRadius: 6, background: .red)
                            .frame(width: 300, height: 200)
                        Placeholder(cornerRadius: 6, background: .yellow)
                            .frame(width: 300, height: 200)
                        Placeholder(cornerRadius: 6, background: .green)
                            .frame(width: 300, height: 200)
                        Placeholder(cornerRadius: 6, background: .blue)
                            .frame(width: 300, height: 200)
                    } else {
                        ForEach(template.previewImageFiles.sorted(), id: \.self) { path in
                            Image(nsImage: NSImage(contentsOf: path.url)!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 200)
                                .cornerRadius(6)
                                .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(Color(.sRGB, white: 0, opacity: 0.2), lineWidth: 0.5))
                        }
                    }
                }.fixedSize()
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 14, trailing: 40))
            }
        }
    }
}
