//
//  AyahViewModel.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

class AyahViewModel: BaseViewModel {
    let sectionCount = 2
    var surah: Surah!
    var items: [AyahViewModelItem]!
    
    init(surah: Surah) {
        self.surah = surah
        items = surah.ayahs.compactMap({AyahViewModelItem($0)})
        
        if let transliteration = PersistentManager.shared.transliteration, let uthmani = PersistentManager.shared.quranUthmani {
            let surahIndex = surah.number - 1
            for (index, item) in items.enumerated() {
                item.uthmani = uthmani.surahs[surahIndex].ayahs[index].text
                item.transliteration = transliteration.surahs[surahIndex].ayahs[index].text
            }
        }
    }
    
    func headerTitleFor(section: Int) -> String? {
        return section == 1 ? LocalizedConstants.Surah.Ayahs : nil
    }
    
    func playSound(_ index: Int) {
        let item = items[index]
        SoundPlayManager.shared.playAyahSound(ayahNumber: item.ayah.number)
    }
    
    func stopSound() {
        SoundPlayManager.shared.stopSound()
    }
    
}


class AyahViewModelItem: ViewModelItem {
    var uthmani: String?
    var transliteration: String?
    var ayah: Ayah
    
    init(_ ayah: Ayah) {
        self.ayah = ayah
    }
}
