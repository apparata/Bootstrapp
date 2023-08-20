//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import Combine
import BootstrappKit

class TemplatesModel: ObservableObject {
    
    typealias TemplateType = BootstrappSpecification.ProjectType
    
    private static let bookmarkID = "template_root_folder"

    @Published var templateSelection: TemplateModel?
    
    var hasTemplates: Bool {
        guard let bootstrappTemplates = bootstrappTemplates else {
            return false
        }
        return bootstrappTemplates.templates.count > 0
    }
    
    @Published var templatesByCategory: [String: [TemplateModel]]
    
    private var bootstrappTemplates: Templates?
    
    private var templatesChangedSubscription: AnyCancellable?
    
    init() {
        bootstrappTemplates = nil
        templatesByCategory = [:]
        
        if let templates = Templates(bookmarkID: Self.bookmarkID) {
            bootstrappTemplates = templates
            templatesByCategory = Self.organizeTemplatesByCategory(from: templates)
            subscribeToTemplateChanges()
        }
    }
    
    private func subscribeToTemplateChanges() {
        templatesChangedSubscription = bootstrappTemplates?.$templates
            .sink { [weak self] _ in
                guard let templates = self?.bootstrappTemplates else {
                    return
                }
                let categorizedTemplates = Self.organizeTemplatesByCategory(from: templates)
                DispatchQueue.main.async {
                    self?.bootstrappTemplates = templates
                    self?.templatesByCategory = categorizedTemplates
                    self?.templateSelection = nil
                }
            }
    }
        
    func setTemplateRootFolder(at url: URL) {
        if let templates = Templates(url: url) {
            let categorizedTemplates = Self.organizeTemplatesByCategory(from: templates)
            DispatchQueue.main.async { [weak self] in
                self?.bootstrappTemplates = templates
                self?.templatesByCategory = categorizedTemplates
                self?.templateSelection = nil
                do {
                    try url.persistAsBookmark(id: Self.bookmarkID)
                } catch {
                    dump(url)
                }
                self?.subscribeToTemplateChanges()
            }
        }
    }
    
    func unsetTemplateRootFolder() {
        URL.deleteBookmark(id: Self.bookmarkID)
        bootstrappTemplates = nil
        templatesByCategory = [:]
        templateSelection = nil
    }
    
    func templates(by category: String) -> [TemplateModel] {
        templatesByCategory[category] ?? []
    }
    
    private static func organizeTemplatesByCategory(from templates: Templates) -> [String: [TemplateModel]] {
                
        var templatesByCategory: [String: [TemplateModel]] = [:]

        for template in templates.sortedTemplates {
            templatesByCategory[template.specification.type.category, default: []].append(TemplateModel(template: template))
        }
        
        return templatesByCategory
    }
}
