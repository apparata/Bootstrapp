//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import SwiftUI
import Splash

public struct SplashSwiftUIOutputFormat: OutputFormat {

    public var theme: Theme

    public init(theme: Theme) {
        self.theme = theme
    }

    public func makeBuilder() -> Builder {
        return Builder(theme: theme)
    }
}

public extension SplashSwiftUIOutputFormat {
    
    struct Builder: OutputBuilder {
        
        private var text = Text("")
        private let theme: Theme
        private lazy var font: SwiftUI.Font = .system(size: CGFloat(theme.font.size),
                                                      weight: .regular,
                                                      design: .monospaced)

        fileprivate init(theme: Theme) {
            self.theme = theme
        }

        public mutating func addToken(_ token: String, ofType type: TokenType) {
            let color = theme.tokenColors[type] ?? Splash.Color.white
            text = text + Text(token).font(font).foregroundColor(Color(color))
        }

        public mutating func addPlainText(_ text: String) {
            self.text = self.text + Text(text).font(font).foregroundColor(Color(theme.plainTextColor))
        }

        public mutating func addWhitespace(_ whitespace: String) {
            text = text + Text(whitespace).font(font).foregroundColor(Color.white)
        }

        public func build() -> Text {
            return text
        }
    }
}
