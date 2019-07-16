//
//  PrayerNotificationViewCell.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/21/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PrayerNotificationViewCell: BaseTableCellSubtitle, ConfigurableCell {
    // MARK: - Variables
    var viewModelItem: PrayerNotificationViewModelItem!
    var valueChanged: Dynamic<PrayerNotificationMO>!
    
    // MARK: Views
    lazy var switchButton: UISwitch = {
       let switchButton = UISwitch()
        switchButton.addTarget(self, action: .switchValueChangeAction, for: .valueChanged)
        return switchButton
    }()
    
    // MARK: Functions
    override func setupViews() {
        super.setupViews()
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? PrayerNotificationViewModelItem else { return }
        self.viewModelItem = viewModelItem
        self.valueChanged = Dynamic(viewModelItem.prayerNotification)
        
        imageView?.image = UIImage(named: viewModelItem.type.iconName())
        textLabel?.text = viewModelItem.titleText
        detailTextLabel?.text = viewModelItem.subtitleText
        selectionStyle = viewModelItem.isSelectable ? .default : .none
        
        switchButton.isOn = viewModelItem.prayerNotification.status
        accessoryView = switchButton
        
        updateSwitchRelatedUI(isEnable: switchButton.isOn)
    }
    
    private func updateSwitchRelatedUI(isEnable: Bool) {
        imageView?.tintColor = isEnable ? textLabel?.tintColor : UIColor.lightGray
        textLabel?.isEnabled = isEnable
        detailTextLabel?.isEnabled = isEnable
    }
    
    @objc func switchValueChanged() {
        updateSwitchRelatedUI(isEnable: switchButton.isOn)
        viewModelItem.prayerNotification.status = switchButton.isOn
        
        valueChanged.value = viewModelItem.prayerNotification
    }
}

fileprivate extension Selector {
    static let switchValueChangeAction = #selector(PrayerNotificationViewCell.switchValueChanged)
}
