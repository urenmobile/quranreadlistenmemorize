//
//  PrayerSoundSelectionViewModel.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 3/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class PrayerSoundSelectionViewModel: BaseViewModel {
    let sectionCount = 1
    var items = [PrayerSoundSelectionViewModelItem]()
    var selectedSound = Dynamic(PersistentManager.shared.defaultPrayerSound)
    
    func findIndexPath(_ prayerSound: PrayerSoundMO) -> IndexPath {
        var indexPath = IndexPath(row: 0, section: 0)
        if let index = items.firstIndex(where: { $0.prayerSound == prayerSound }) {
            indexPath.row = index
        }
        return indexPath
    }
    
    func getSounds() {
        let sounds = PersistentManager.shared.fetch(PrayerSoundMO.self).sorted(by: { $0.name < $1.name})
        items = sounds.compactMap({ PrayerSoundSelectionViewModelItem($0)})
    }
}

class PrayerSoundSelectionViewModelItem: ViewModelItem {
    var prayerSound: PrayerSoundMO
    
    var titleText: String {
        return NSLocalizedString(prayerSound.localizedKey, comment: "")
    }
    
    init(_ prayerSound: PrayerSoundMO) {
        self.prayerSound = prayerSound
    }
}
