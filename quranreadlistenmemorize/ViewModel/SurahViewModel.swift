//
//  SurahViewModel.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class SurahViewModel: BaseViewModel {
    var items = [[SurahViewModelItem]]()
    var state = Dynamic(State.loading)
    
    func getSelectedQuranEdition() {
        state.value = .loading
        
        items.removeAll()
        if let quran = PersistentManager.shared.selectedQuran {
            let surahs = quran.surahs.compactMap({ SurahViewModelItem(surah: $0)})
            items.append(surahs)
        }
        state.value = .populate
    }
    
    func headerTitleFor(section: Int) -> String {
        return LocalizedConstants.Surah.Surahs
    }
}

class SurahViewModelItem: ViewModelItem {
    var surah: Surah
    
    var surahTitleName: String? {
        return PersistentManager.shared.isTurkishLanguage ? PersistentManager.shared.turkishSurahNames[surah.number-1] + Constants.Suresi : (PersistentManager.shared.isArabicLanguage ? surah.name : surah.englishName)
    }
    
    var surahText: String? {
        if let surahNumber = surah.number, let surahTitleName = surahTitleName {
            return "\(surahNumber).  " + surahTitleName
        }
        return surahTitleName
    }
    
    init(surah: Surah) {
        self.surah = surah
    }
}
