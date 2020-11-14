//
//  EditionViewModel.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation
import CoreData
import NetworkPackage

class EditionViewModel: BaseViewModel {
    var items = [[EditionViewModelItem]]()
    var isEditionChanged = Dynamic(false)
    var willDownloadItem: EditionViewModelItem!
    
    var selectedEdition: EditionMO {
        get {
            return PersistentManager.shared.appConfiguration.edition
        }
        set {
            PersistentManager.shared.appConfiguration.edition = newValue
            PersistentManager.shared.saveContext()
            isEditionChanged.value = true
        }
    }
    
    let state = Dynamic(State.loading)
    var downloadCompletion: ((NetworkResult<(sourceUrl: URL, location: URL)>) -> Void)?
    
    lazy var fetchedResultController: NSFetchedResultsController<EditionMO> = {
        var fetchRequest: NSFetchRequest<EditionMO> = EditionMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "language", ascending: true), NSSortDescriptor(key: "englishName", ascending: true)]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistentManager.shared.context, sectionNameKeyPath: "language", cacheName: nil)
        return fetchedResultController
    }()
    
    func getEditions() {
        state.value = .loading
        do {
            try fetchedResultController.performFetch()
            if let sections = fetchedResultController.sections {
                items = sections.compactMap({ $0.objects as? [EditionMO] })
                    .compactMap({ $0.compactMap({ EditionViewModelItem($0) }) })
                items.sort(by: { $0[0].languageName < $1[0].languageName })
            }
            
        } catch let error {
            debugPrint("ERROR: \(error)")
        }
        state.value = .populate
        
    }
    
    func findSelectedIndexPath() -> IndexPath {
        for (section, editions) in items.enumerated() {
            for (row, edition) in editions.enumerated() {
                if selectedEdition == edition.edition {
                    return IndexPath(row: row, section: section)
                }
            }
        }
        
        return IndexPath(row: 0, section: 0)
    }
    
    func indexPathFor(_ item: EditionViewModelItem) -> IndexPath {
        for (section, editions) in items.enumerated() {
            for (row, edition) in editions.enumerated() {
                if item.edition == edition.edition {
                    return IndexPath(row: row, section: section)
                }
            }
        }
        
        return IndexPath(row: 0, section: 0)
    }
    
    func downloadEdition(identifier: String) {
        willDownloadItem.isDownloading = true
        APIManager.shared.completion = downloadCompletion
        
        let request = Endpoints.Paths.quranEditions.asUrlRequest(with: [identifier])
        APIManager.shared.startDownloadProgress(with: request)
    }
}

class EditionViewModelItem: ViewModelItem {
    var edition: EditionMO
    
    var isBundleFile: Bool {
        return PersistentManager.shared.isBundleFile(edition.identifier)
    }
    var downloaded: Bool {
        return FileOperationManager.shared.checkFileExists(identifier: edition.identifier)
    }
    var isDownloading = false
    
    init(_ edition: EditionMO) {
        self.edition = edition
    }
    
    var languageName: String {
        return (NSLocale.current as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: edition.language) ?? "Invalid language code"
    }
    
}
