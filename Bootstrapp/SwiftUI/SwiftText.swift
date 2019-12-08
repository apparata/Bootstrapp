//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import Splash

struct SwiftText: View {
    
    var string: String
    private let theme: Splash.Theme
    
    var body: some View {
        highlightSwift(string, theme: theme)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(theme.backgroundColor))
            .cornerRadius(6)
            // Workaround, or the text will be truncated
            .fixedSize(horizontal: false, vertical: true)
    }
    
    init(_ string: String, theme: Splash.Theme = .sundellsColors(withFont: Font(size: 13))) {
        self.string = string
        self.theme = theme
    }
    
    private func highlightSwift(_ string: String, theme: Splash.Theme) -> Text {
        let highlighter = SyntaxHighlighter(format: SplashSwiftUIOutputFormat(theme: theme))
        let text = highlighter.highlight(string)
        return text
    }
}


