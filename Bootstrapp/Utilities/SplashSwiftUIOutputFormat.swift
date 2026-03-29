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

        private var attributedString = AttributedString()
        private let theme: Theme
        private lazy var font: SwiftUI.Font = .system(size: CGFloat(theme.font.size),
                                                      weight: .regular,
                                                      design: .monospaced)

        fileprivate init(theme: Theme) {
            self.theme = theme
        }

        public mutating func addToken(_ token: String, ofType type: TokenType) {
            let color = theme.tokenColors[type] ?? Splash.Color.white
            var segment = AttributedString(token)
            segment.font = font
            segment.foregroundColor = Color(color)
            attributedString.append(segment)
        }

        public mutating func addPlainText(_ text: String) {
            var segment = AttributedString(text)
            segment.font = font
            segment.foregroundColor = Color(theme.plainTextColor)
            attributedString.append(segment)
        }

        public mutating func addWhitespace(_ whitespace: String) {
            var segment = AttributedString(whitespace)
            segment.font = font
            segment.foregroundColor = Color.white
            attributedString.append(segment)
        }

        public func build() -> Text {
            return Text(attributedString)
        }
    }
}
