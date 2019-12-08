//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import Combine
import BootstrappKit

class TemplatesViewModel: ObservableObject {
    
    typealias TemplateType = BootstrappSpecification.ProjectType
    
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var templateSelection: BootstrappTemplate?
    
    var hasTemplates: Bool {
        bootstrappTemplates.templates.count > 0
    }
        
    var templatesByCategory: [String: [TemplateViewModel]]
    
    private var bootstrappTemplates: Templates
    private var cancellables = Set<AnyCancellable>()
    
    init(templates: Templates) {
        bootstrappTemplates = templates
        templatesByCategory = Self.organizeTemplatesByCategory(from: templates)
        
        bootstrappTemplates.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send(())
            self?.templatesByCategory = Self.organizeTemplatesByCategory(from: templates)
        }
        .store(in: &cancellables)
    }
    
    func templates(by category: String) -> [TemplateViewModel] {
        templatesByCategory[category] ?? []
    }
    
    private static func organizeTemplatesByCategory(from templates: Templates) -> [String: [TemplateViewModel]] {
                
        var templatesByCategory: [String: [TemplateViewModel]] = [:]

        for template in templates.sortedTemplates {
            templatesByCategory[template.specification.type.category, default: []].append(TemplateViewModel(template: template))
        }
        
        return templatesByCategory
    }
}
