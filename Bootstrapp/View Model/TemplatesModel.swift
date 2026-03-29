//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import BootstrappKit
import SwiftUI
import Observation

@MainActor
@Observable
class TemplatesModel {

    typealias TemplateType = BootstrappSpecification.ProjectType

    private static let bookmarkID = "template_root_folder"

    var templateSelection: TemplateModel?

    var hasTemplates: Bool {
        guard let bootstrappTemplates = bootstrappTemplates else {
            return false
        }
        return bootstrappTemplates.templates.count > 0
    }

    var templatesByCategory: [String: [TemplateModel]]

    private var bootstrappTemplates: Templates?

    init() {
        bootstrappTemplates = nil
        templatesByCategory = [:]

        if let templates = Templates(bookmarkID: Self.bookmarkID) {
            bootstrappTemplates = templates
            templatesByCategory = Self.organizeTemplatesByCategory(from: templates)
            observeTemplateChanges()
        }
    }

    private func observeTemplateChanges() {
        withObservationTracking {
            _ = bootstrappTemplates?.templates
        } onChange: { [weak self] in
            Task { @MainActor [weak self] in
                guard let self, let templates = self.bootstrappTemplates else {
                    return
                }
                self.templatesByCategory = Self.organizeTemplatesByCategory(from: templates)
                self.templateSelection = nil
                self.observeTemplateChanges()
            }
        }
    }

    func setTemplateRootFolder(at url: URL) {
        if let templates = Templates(url: url) {
            let categorizedTemplates = Self.organizeTemplatesByCategory(from: templates)
            withAnimation {
                bootstrappTemplates = templates
                templatesByCategory = categorizedTemplates
                templateSelection = nil
            }
            do {
                try url.persistAsBookmark(id: Self.bookmarkID)
            } catch {
                dump(url)
            }
            observeTemplateChanges()
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
