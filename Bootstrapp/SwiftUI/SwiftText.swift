//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import Splash

struct SwiftText: View {
    
    var string: String
    private let lightTheme: Splash.Theme
    private let darkTheme: Splash.Theme
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        highlightSwift(string, theme: (colorScheme == .dark) ? darkTheme : lightTheme)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(((colorScheme == .dark) ? darkTheme : lightTheme).backgroundColor))
            .cornerRadius(6)
            // Workaround, or the text will be truncated
            .fixedSize(horizontal: false, vertical: true)
    }
    
    init(_ string: String, lightTheme: Splash.Theme = .sundellsColors(withFont: Font(size: 13)), darkTheme: Splash.Theme = .midnight(withFont: Font(size: 13))) {
        self.string = string
        self.lightTheme = lightTheme
        self.darkTheme = darkTheme
    }
    
    private func highlightSwift(_ string: String, theme: Splash.Theme) -> Text {
        let highlighter = SyntaxHighlighter(format: SplashSwiftUIOutputFormat(theme: theme))
        let text = highlighter.highlight(string)
        return text
    }
}


