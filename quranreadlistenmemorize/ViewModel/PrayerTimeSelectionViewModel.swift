//
//  PrayerTimeSelectionViewModel.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 3/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class PrayerTimeSelectionViewModel: BaseViewModel {
    let sectionCount = 1
    let items: [Int] = [5, 10, 15, 20, 25, 30, 45, 60, 90, 120]
    let selectedTime = Dynamic(0)
    
    func textFor(item: Int) -> String {
        return "\(item) " + LocalizedConstants.Prayer.MinutesBefore
    }
    
    func findIndexPath(_ item: Int) -> IndexPath {
        var indexPath = IndexPath(row: 0, section: 0)
        if let index = items.firstIndex(of: item) {
            indexPath.row = index
        }
        return indexPath
    }
}
