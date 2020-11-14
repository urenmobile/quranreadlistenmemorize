//
//  MainTabBarController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/6/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MainTabBarController: BaseTabBarController {
    // MARK: - Variables
    
    // MARK: - Views
    let prayerTimeViewController: PrayerTimeViewController = {
        let viewController = PrayerTimeViewController(style: .grouped)
        viewController.viewModel = PrayerTimeViewModel()
        return viewController
    }()
    
    let surahViewController: SurahViewController = {
        let viewController = SurahViewController(style: .grouped)
        viewController.viewModel = SurahViewModel()
        return viewController
    }()
    
    let moreViewController: MoreViewController = {
        let viewController = MoreViewController(style: .grouped)
        viewController.viewModel =  MoreViewModel()
        return viewController
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        
        prayerTimeViewController.tabBarItem = UITabBarItem(title: prayerTimeViewController.iconTitle, image: prayerTimeViewController.icon, tag: 0)
        surahViewController.tabBarItem = UITabBarItem(title: surahViewController.iconTitle, image: surahViewController.icon, tag: 1)
        moreViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        let controllers = [prayerTimeViewController, surahViewController, moreViewController]
        viewControllers = controllers.compactMap({ BaseNavigationController(rootViewController: $0) })
    }
}
