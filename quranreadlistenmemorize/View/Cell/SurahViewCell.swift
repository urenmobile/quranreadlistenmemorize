//
//  SurahViewCell.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SurahViewCell: BaseTableCellRightDetail, ConfigurableCell {
    
    // MARK: - Variables
    var viewModelItem: SurahViewModelItem!
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        accessoryType = .none
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? SurahViewModelItem else { return }
        self.viewModelItem = viewModelItem
        
        textLabel?.text = viewModelItem.surahText
        if let ayahs = viewModelItem.surah.ayahs {
            detailTextLabel?.text = "\(ayahs.count)"
        }
        accessoryType = .disclosureIndicator
    }
    
    
    
}
