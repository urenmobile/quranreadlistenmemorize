//
//  AyahViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class AyahViewController: BaseTableViewController {
    
    var viewModel: AyahViewModel!
    
    override func setupViews() {
        super.setupViews()
        setupNavigation()
        setupTableView()
    }
    
    func setupNavigation() {
        
    }
    
    func setupTableView() {
        tableView.register(BaseTableCell.self, forCellReuseIdentifier: BaseTableCell.identifier)
        tableView.register(AyahViewCell.self, forCellReuseIdentifier: AyahViewCell.identifier)
    }
    
    func setupViewModel() {
        
    }
    
    deinit {
        viewModel.stopSound()
    }
}

extension AyahViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Surah arabic name
        if indexPath == IndexPath(row: 0, section: 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableCell.identifier, for: indexPath) as? BaseTableCell {
                cell.textLabel?.text = viewModel.surah.name
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
                return cell
            }
        }
        
        let item = viewModel.items[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: AyahViewCell.identifier, for: indexPath) as? AyahViewCell {
            cell.configure(viewModelItem: item)
            cell.detailConfigure(surah: viewModel.surah)
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitleFor(section: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        viewModel.playSound(indexPath.row)
    }
}
