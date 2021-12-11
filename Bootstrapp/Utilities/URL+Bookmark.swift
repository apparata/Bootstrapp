//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

private func bookmarkKey(from id: String) -> String {
    "scopedbookmark_\(id)"
}

extension URL {
    
    // Remember to use `` before accessing
    // and `stopAccessingSecurityScopedResource()` after accessing file.
    
    func startAccessingBookmarkedURL() {
        if !startAccessingSecurityScopedResource() {
            print("Function startAccessingSecurityScopedResource() return false, ignoring.")
        }
    }
    
    func stopAccessingBookmarkedURL() {
        stopAccessingSecurityScopedResource()
    }
    
    static func deleteBookmark(id: String) {
        UserDefaults.standard.removeObject(forKey: bookmarkKey(from: id))
    }
    
    func persistAsBookmark(id: String) throws {
        let bookmarkData = try bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil)
        UserDefaults.standard.set(bookmarkData, forKey: bookmarkKey(from: id))
    }
    
    static func restoreFromBookmark(id: String) throws -> URL? {
        guard let bookmarkData = UserDefaults.standard.data(forKey: bookmarkKey(from: id)) else {
            return nil
        }
        
        var isStale = false
        let url = try URL(
            resolvingBookmarkData: bookmarkData,
            options: .withSecurityScope,
            relativeTo: nil,
            bookmarkDataIsStale: &isStale)
        if isStale {
            // Apparently, we should re-persist it. Not sure how this works.
            try url.persistAsBookmark(id: bookmarkKey(from: id))
        }
        return url
    }
}
