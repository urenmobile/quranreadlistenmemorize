//
//  DhikrViewModel.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/19/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class DhikrViewModel: BaseViewModel {
    var items = [[DhikrViewModelItem]]()
    
    let state = Dynamic(State.loading)
    
    func getDhikrs() {
        state.value = .loading
        let dhikrs = PersistentManager.shared.fetch(DhikrMO.self).sorted(by: {$0.name < $1.name})
        items.append(dhikrs.compactMap({ DhikrViewModelItem(dhikr: $0) }))
        state.value = items.isEmpty ? .empty : .populate
    }
}

class DhikrViewModelItem: ViewModelItem {
    var dhikr: DhikrMO
    
    init(dhikr: DhikrMO) {
        self.dhikr = dhikr
    }
}
