
import Foundation
import BootstrappKit
import Markin
import SwiftUI
import Combine
import SystemKit

public class Templates: ObservableObject {
        
    @Published var templates = Set<BootstrappTemplate>()
    
    var sortedTemplates: [BootstrappTemplate] {
        Array(templates).sorted(by: \.specification.id)
    }
    
    private var changeStream: FileEventStream?
    
    private var changeSubscription: AnyCancellable?
    
    private var bookmark: URL?
    
    public init?(url: URL) {
        do {
            try loadTemplates(at: url)
            monitorChanges(at: url)
        } catch {
            dump(error)
            return nil
        }
    }
    
    public init?(bookmarkID: String) {
        do {
            guard let url = try URL.restoreFromBookmark(id: bookmarkID) else {
                return nil
            }
            bookmark = url
            url.startAccessingBookmarkedURL()
            do {
                try loadTemplates(at: url)
            } catch {
                dump(error)
                bookmark = nil
                url.stopAccessingBookmarkedURL()
            }
            monitorChanges(at: url)
        } catch {
            dump(error)
            return nil
        }
    }
    
    deinit {
        if let url = bookmark {
            url.stopAccessingBookmarkedURL()
        }
    }
    
    private func monitorChanges(at url: URL) {
        do {
            let fileEventStream = try FileEventStream(paths: [url.path])
            changeSubscription = fileEventStream
                .sink { [weak self] event in
                    do {
                        try self?.loadTemplates(at: url)
                    } catch {
                        dump(error)
                    }
                }
            changeStream = fileEventStream
        } catch {
            dump(error)
        }
    }
    
    private func loadTemplates(at url: URL) throws {
        
        let path = BootstrappKit.Path(url.path)
        
        var bootstrappTemplates = Set<BootstrappTemplate>()
        
        // A template is loaded by its Bootstrapp.json file.
        
        if path.isDirectory {
            // This is a directory, let's try to find all templates in it.
            let subpaths = try path.recursiveContentsOfDirectory()
            for subpath in subpaths {
                if !subpath.isDirectory && subpath.lastComponent == "Bootstrapp.json" {
                    let subpathURL = url.appendingPathComponent(subpath.string)
                    let template = try Self.loadTemplate(at: subpathURL)
                    bootstrappTemplates.insert(template)
                }
            }
        }
        
        self.templates = bootstrappTemplates
    }
    
    private static func loadTemplate(at url: URL) throws -> BootstrappTemplate {
        
        let baseURL = url.deletingLastPathComponent()
        
        let specification = try loadSpecification(at: url)
        let document = try? loadMarkinDocument(at: baseURL.appendingPathComponent("Bootstrapp.md"))
        
        let previewImageFiles = collectPreviewImageFiles(at: baseURL.appendingPathComponent("Preview"))
        
        let template = BootstrappTemplate(id: specification.id,
                                          url: url.deletingLastPathComponent(),
                                          specification: specification,
                                          document: document,
                                          previewImageFiles: previewImageFiles,
                                          presetsPath: Bundle.main.resourcePath.map { Path($0) })
        return template
    }
    
    private static func loadSpecification(at url: URL) throws -> BootstrappSpecification {
        let data = try Data(contentsOf: url)
        let specification = try JSONDecoder().decode(BootstrappSpecification.self, from: data)
        return specification
    }
    
    private static func loadMarkinDocument(at url: URL) throws -> DocumentElement {
        let string = try String(contentsOf: url)
        let parser = MarkinParser()
        let document = try parser.parse(string)
        return document
    }
    
    private static func collectPreviewImageFiles(at url: URL) -> [BootstrappKit.Path] {
        let path = BootstrappKit.Path(url.path)
        guard path.exists else {
            return []
        }
        do {
            return try path.recursiveContentsOfDirectory(fullPaths: true).filter {
                ["png", "jpg", "jpeg"].contains($0.extension)
            }
        } catch {
            return []
        }
    }
}
