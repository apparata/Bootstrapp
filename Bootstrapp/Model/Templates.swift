
import Foundation
import BootstrappKit
import Markin
import SwiftUI
import Combine

public class Templates: ObservableObject {
    
    public var objectWillChange = PassthroughSubject<Void, Never>()
    
    var templates = Set<BootstrappTemplate>()
    
    var sortedTemplates: [BootstrappTemplate] {
        Array(templates).sorted(by: \.specification.id)
    }
    
    public init() {
    }
    
    func addTemplate(at url: URL) throws {
        let path = BootstrappKit.Path(url.path)
        var bootstrappTemplates = Set<BootstrappTemplate>()
        if path.isDirectory {
            let subpaths = try path.recursiveContentsOfDirectory()
            for subpath in subpaths {
                if !subpath.isDirectory && subpath.lastComponent == "Bootstrapp.json" {
                    let subpathURL = url.appendingPathComponent(subpath.string)
                    let template = try Self.loadTemplate(at: subpathURL)
                    bootstrappTemplates.insert(template)
                }
            }
        } else if path.lastComponent == "Bootstrapp.json" {
            let template = try Self.loadTemplate(at: url)
            bootstrappTemplates.insert(template)
        } else {
            return
        }
        
        DispatchQueue.main.async {
            self.templates.formUnion(bootstrappTemplates)
            self.objectWillChange.send(())
        }
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
