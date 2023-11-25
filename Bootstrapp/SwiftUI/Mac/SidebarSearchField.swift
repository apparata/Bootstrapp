//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if os(macOS)

import AppKit
import SwiftUI

struct SidebarSearchField: NSViewRepresentable {
    
    @Binding var text: String
    
    private var placeholder: String

    init(text: Binding<String>, placeholder: String = "Search") {
        _text = text
        self.placeholder = placeholder
    }

    func makeNSView(context: Context) -> NSVisualEffectView {
        let wrapperView = NSVisualEffectView()
        let searchField = NSSearchField(string: placeholder)
        searchField.delegate = context.coordinator
        searchField.isBordered = false
        searchField.isBezeled = true
        searchField.bezelStyle = .roundedBezel
        searchField.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            searchField.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),
            searchField.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor)
        ])
        return wrapperView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        (nsView.subviews[0] as? NSSearchField)?.stringValue = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator { self.text = $0 }
    }

    final class Coordinator: NSObject, NSSearchFieldDelegate {
        var mutator: (String) -> Void

        init(_ mutator: @escaping (String) -> Void) {
            self.mutator = mutator
        }

        func controlTextDidChange(_ notification: Notification) {
            if let textField = notification.object as? NSTextField {
                mutator(textField.stringValue)
            }
        }
    }
}

#endif

