//
//  MoreViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/19/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class MoreViewController: BaseTableViewController {
    
    // MARK: - Variables
    var viewModel: MoreViewModel!
    
    // MARK: - Views
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        
        setupNavigation()
        setupTableView()
        setupViewModel()
    }
    
    func setupNavigation() {
    }
    
    private func setupTableView() {
        tableView.register(BaseTableCellRightDetail.self, forCellReuseIdentifier: BaseTableCellRightDetail.identifier)
    }
    
    func setupViewModel() {
        
    }
}

extension MoreViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableCellRightDetail.identifier, for: indexPath) as? BaseTableCellRightDetail {
            cell.textLabel?.text = item.type.localized()
            cell.imageView?.image = UIImage(named: item.type.iconName())
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        switch item.type {
        case .qibla:
            let qiblaViewController = QiblaViewController()
            qiblaViewController.navigationItem.title = item.type.localized()
            qiblaViewController.backgroundColor = #colorLiteral(red: 0.1647058824, green: 0.1803921569, blue: 0.262745098, alpha: 1)
            self.navigationController?.pushViewController(qiblaViewController, animated: true)
        case .dhikr:
            let dhikrViewController = DhikrViewController(style: .grouped)
            dhikrViewController.viewModel = DhikrViewModel()
            self.navigationController?.pushViewController(dhikrViewController, animated: true)
        case .holyDayMessage:
            let holyDayMessageViewController = HolyDayMessageViewController()
            holyDayMessageViewController.view.backgroundColor = UIColor.white
            self.navigationController?.pushViewController(holyDayMessageViewController, animated: true)
        }
    }
}
