//
//  MoreViewModel.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/19/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class MoreViewModel: BaseViewModel {
    var items = [[MoreViewModelItem]]()
    
    override func setup() {
        super.setup()
        let qibla = MoreViewModelItem(.qibla)
        let dhikr = MoreViewModelItem(.dhikr)
        let holyDayMessage = MoreViewModelItem(.holyDayMessage)
        
        items = [[qibla, dhikr, holyDayMessage]]
    }
}

enum MoreViewModelItemType {
    case qibla
    case dhikr
    case holyDayMessage
    
    func localized() -> String {
        switch self {
        case .qibla:
            return LocalizedConstants.More.Qibla
        case .dhikr:
            return LocalizedConstants.More.Dhikr
        case .holyDayMessage:
            return LocalizedConstants.More.HolyDayMessage
        }
    }
    
    func iconName() -> String {
        switch self {
        case .qibla:
            return Icon.qibla.rawValue
        case .dhikr:
            return Icon.dhikr.rawValue
        case .holyDayMessage:
            return Icon.message.rawValue
        }
    }
}

class MoreViewModelItem: ViewModelItem {
    var type: MoreViewModelItemType
    
    init(_ type: MoreViewModelItemType) {
        self.type = type
    }
}
