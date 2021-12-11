//
//  Copyright © 2019 Bontouch AB. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers
import BootstrappKit

struct MainView: View {
    
    var templates: Templates
    
    var mainWindowState: MainWindowState
        
    var body: some View {
        MainSplitView()
            .layoutPriority(1.0)
            .onDrop(of: [UTType.fileURL], delegate: self)
    }
}

extension MainView: DropDelegate {

    /// Called when a drop, which has items conforming to any of the types
    /// passed to the onDrop() modifier, enters an onDrop target.
    func validateDrop(info: DropInfo) -> Bool {
        return true
    }

    /// Tells the delegate it can request the item provider data from the
    /// DropInfo incorporating it into the application's data model as
    /// appropriate. This function is required.
    ///
    /// Return `true` if the drop was successful, `false` otherwise.
    func performDrop(info: DropInfo) -> Bool {
        
        let itemProviders = info.itemProviders(for: [UTType.fileURL])

        guard itemProviders.count > 0 else {
            return false
        }

        for itemProvider in itemProviders {
                        
            itemProvider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                            
                guard let data = item as? Data else {
                    dump(error)
                    return
                }
                
                guard let url = URL(dataRepresentation: data, relativeTo: nil) else {
                    print("Error: Not a valid URL.")
                    return
                }
                
                DispatchQueue.global().async {
                    do {
                        try self.templates.addTemplate(at: url)
                    } catch {
                        dump(error)
                    }
                }
            }
        }
        
        return true
    }

    func dropEntered(info: DropInfo) {
        //print("Drop entered!")
        mainWindowState.isHoveringOverDropZone = true
        mainWindowState.hoverLocation = info.location
    }

    /// Called as a validated drop moves inside the onDrop modified view.
    ///
    /// Return a drop proposal that contains the operation the delegate intends
    /// to perform at the DropInfo.location, The default implementation returns
    /// nil, which tells the drop to use that last valid returned value or else
    /// .copy.
    func dropUpdated(info: DropInfo) -> DropProposal? {
        mainWindowState.hoverLocation = info.location
        return nil
    }

    /// Tells the delegate a validated drop operation has exited the onDrop
    /// modified view. The default behavior does nothing.
    func dropExited(info: DropInfo) {
        //print("Drop exited!")
        self.mainWindowState.isHoveringOverDropZone = false
        mainWindowState.hoverLocation = info.location
    }
}
