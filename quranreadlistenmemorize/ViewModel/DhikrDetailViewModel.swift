//
//  DhikrDetailViewModel.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/18/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class DhikrDetailViewModel: BaseViewModel {
    var dhikr: DhikrMO
    
    let maxValue: Double = 1
    var startValue: Double {
        return Double(dhikr.remainingCount) / Double(dhikr.totalCount)
    }
    
    lazy var unitCount: Double = {
        return dhikr.remainingCount != 0 ? maxValue / Double(dhikr.totalCount) : 0
    }()
    
    var endValue: Double {
        return startValue - unitCount
    }
    
    init(dhikr: DhikrMO) {
        self.dhikr = dhikr
    }
    
    // return true when start round again
    func updateCountDown(){
        dhikr.remainingCount -= 1
        if dhikr.remainingCount <= 0 {
            dhikr.remainingCount = dhikr.totalCount
            dhikr.roundCount += 1
        }
        saveData()
    }
    
    func reset() {
        dhikr.remainingCount = dhikr.totalCount
        dhikr.roundCount = 0
        saveData()
    }
    
    func saveData() {
        PersistentManager.shared.saveContext()
    }
    
    func checkCounterRestart() -> Bool {
        return dhikr.remainingCount == dhikr.totalCount
    }
    
    func changeSoundOnOff() {
        dhikr.isSoundOn = !dhikr.isSoundOn
        saveData()
    }
    
}
