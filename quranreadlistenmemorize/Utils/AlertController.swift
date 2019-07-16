//
//  AlertController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/25/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class AlertController {
    
    enum ServiceType {
        case location
        case notification
        
        func localized() -> String {
            switch self {
            case .location:
                return LocalizedConstants.Permission.Location
            case .notification:
                return LocalizedConstants.Permission.Notification
            }
        }
        
        func giveAccessTitle() -> String {
            switch self {
            case .location:
                return LocalizedConstants.Permission.GiveAccessLocationTitle
            case .notification:
                return LocalizedConstants.Permission.GiveAccessNotificationTitle
            }
        }
        
        func giveAccessBody() -> String {
            switch self {
            case .location:
                return LocalizedConstants.Permission.GiveAccessLocationBody
            case .notification:
                return LocalizedConstants.Permission.GiveAccessNotificationBody
            }
        }
        
        func accessDisableTitle() -> String {
            switch self {
            case .location:
                return LocalizedConstants.Permission.AccessDisableLocationTitle
            case .notification:
                return LocalizedConstants.Permission.AccessDisableNotificationTitle
            }
        }
        
        func accessDisableBody() -> String {
            switch self {
            case .location:
                return LocalizedConstants.Permission.GiveAccessLocationBody
            case .notification:
                return LocalizedConstants.Permission.GiveAccessNotificationBody
            }
        }
    }
    
    class func goToSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl)  {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            } else  {
                UIApplication.shared.openURL(settingsUrl)
            }
        }
    }
    
    class func showPrePermissionAlert(_ viewController: UIViewController, serviceType: ServiceType, handler: ((UIAlertAction) -> Void)?) {
        
        let title = serviceType.giveAccessTitle()
        let message = serviceType.giveAccessBody()
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let notNowActionTitle = LocalizedConstants.Permission.NotNow
        let notNowAction = UIAlertAction(title: notNowActionTitle, style: .default, handler: nil)
        
        let giveAccessActionTitle = LocalizedConstants.Permission.GiveAccess
        let giveAccessAction = UIAlertAction(title: giveAccessActionTitle, style: .default, handler: handler)
        
        alertController.addAction(notNowAction)
        alertController.addAction(giveAccessAction)
        
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showAccessDeniedAlert(_ viewController: UIViewController, serviceType: ServiceType) {
        let title = serviceType.accessDisableTitle()
        let message = serviceType.accessDisableBody()
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingActionTitle = LocalizedConstants.Settings
        let settingAction = UIAlertAction(title: settingActionTitle, style: .cancel) { (action) in
            AlertController.goToSettings()
        }
        
        let okActionTitle = LocalizedConstants.Ok
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: nil)
        
        alertController.addAction(settingAction)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
