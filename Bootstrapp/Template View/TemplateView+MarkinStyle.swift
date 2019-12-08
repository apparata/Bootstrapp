//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI
import Markin
import Splash

extension TemplateView {
    
    func makeMarkinStyle() -> MarkinStyle {
        
        //let codeTheme = Splash.Theme.sundellsColors(withFont: Splash.Font(size: 13))
        let codeTheme = Splash.Theme.bootstrapp()
        
        return MarkinStyle(
            spacing: 16,
            header1: .init(font: .system(size: 24, weight: .bold, design: .default),
                           padding: EdgeInsets(top: 10, leading: 0, bottom: 16, trailing: 0)),
            header2: .init(font: .system(size: 18, weight: .bold, design: .default),
                           padding: EdgeInsets(top: 8, leading: 0, bottom: 12, trailing: 0)),
            header3: .init(font: Font.headline.weight(.semibold),
                           padding: EdgeInsets(top: 8, leading: 0, bottom: 12, trailing: 0)),
            header4: .init(font: Font.subheadline.weight(.semibold),
                           padding: EdgeInsets(top: 8, leading: 0, bottom: 12, trailing: 0)),
            header5: .init(font: Font.body.weight(.bold),
                           padding: EdgeInsets(top: 8, leading: 0, bottom: 12, trailing: 0)),
            header6: .init(font: Font.caption.weight(.bold),
                           padding: EdgeInsets(top: 8, leading: 0, bottom: 12, trailing: 0)),
            body: .init(font: .system(size: 14)),
            code: .init(font: .system(size: 13, weight: .regular, design: .monospaced),
                        color: .purple),
            codeBlock: .init(font: .system(size: CGFloat(codeTheme.font.size), weight: .regular, design: .monospaced),
                             background: Color(codeTheme.backgroundColor),
                             cornerRadius: 6,
                             formatter: { element in
                guard element.language?.lowercased() == "swift" else {
                    return nil
                }
                let highlighter = SyntaxHighlighter(format: SplashSwiftUIOutputFormat(theme: codeTheme))
                return highlighter.highlight(element.content)
            }),
            blockQuote: .init(color: .yellow, padding: 16),
            list: .init(font: .system(size: 14),
                        spacing: 8,
                        orderedBulletFont: .system(size: 14),
                        bulletFont: .system(size: 16))
        )
    }
}

extension Splash.Theme {
    
    static func bootstrapp() -> Theme {
        return Theme(
            font: Font(size: 13),
            plainTextColor: NSColor(srgbRed: 0.2, green: 0.2, blue: 0.2, alpha: 1),
            tokenColors: [
                .keyword: NSColor(srgbRed: 0.706, green: 0.0, blue: 0.384, alpha: 1),
                .string: NSColor(srgbRed: 0.729, green: 0.0, blue: 0.067, alpha: 1),
                .type: NSColor(srgbRed: 0.267, green: 0.537, blue: 0.576, alpha: 1),
                .call: NSColor(srgbRed: 0.267, green: 0.537, blue: 0.576, alpha: 1),
                .number: NSColor(srgbRed: 0.0, green: 0.043, blue: 1.0, alpha: 1),
                .comment: NSColor(srgbRed: 0, green: 0.502, blue: 0, alpha: 1),
                .property: NSColor(srgbRed: 0.267, green: 0.537, blue: 0.576, alpha: 1),
                .dotAccess: NSColor(srgbRed: 0.267, green: 0.537, blue: 0.576, alpha: 1),
                .preprocessing: NSColor(srgbRed: 0.431, green: 0.125, blue: 0.051, alpha: 1)
            ],
            backgroundColor: NSColor(srgbRed: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        )
    }
}
