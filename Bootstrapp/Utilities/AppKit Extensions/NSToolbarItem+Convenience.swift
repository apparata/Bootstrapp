//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Cocoa

public extension NSToolbarItem {
    
    // MARK: - Button
    
    convenience init(id: NSToolbarItem.Identifier,
                     target: AnyObject?,
                     selector: Selector?,
                     label: String?,
                     image: NSImage?,
                     toolTip: String?) {
        self.init(itemIdentifier: id)
        let button = NSButton()
        button.bezelStyle = .texturedRounded
        button.target = target
        button.action = selector
        view = button
        if let label = label {
            self.label = label
        }
        self.image = image
        self.toolTip = toolTip
    }
    
    // MARK: - Window Title Label
    
    convenience init(id: NSToolbarItem.Identifier,
                     windowTitle: String) {
        self.init(itemIdentifier: id)
        let label = NSTextField()
        label.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        label.stringValue = windowTitle
        label.backgroundColor = nil
        label.isBezeled = false
        label.isEditable = false
        label.font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: .regular))
        label.alignment = .center
        label.sizeToFit()
        view = label
    }
    
    // MARK: - Segmented Control
    
    convenience init(id: NSToolbarItem.Identifier,
                     labels: [String],
                     selectedSegment: Int = 0,
                     target: AnyObject?,
                     selector: Selector?) {
        self.init(itemIdentifier: id)
        let segmentedControl = NSSegmentedControl(
            labels: labels,
            trackingMode: NSSegmentedControl.SwitchTracking.selectOne,
            target: target,
            action: selector)
        segmentedControl.segmentStyle = .texturedRounded
        segmentedControl.selectedSegment = selectedSegment
        view = segmentedControl
    }
}
