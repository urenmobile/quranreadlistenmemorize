//
//  PrayerTimeSelectionViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/21/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PrayerTimeSelectionViewController: BaseTableViewController {
    
    // MARK: - Variables
    var viewModel: PrayerTimeSelectionViewModel!
    
    // MARK: Views
    
    // MARK: Functions
    override func setupViews() {
        super.setupViews()
        
        setupNavigation()
        setupTableView()
        setupViewModel()
    }
    
    private func setupNavigation() {
        
    }
    
    private func setupTableView() {
        tableView.register(BaseTableCell.self, forCellReuseIdentifier: BaseTableCell.identifier)
    }
    
    private func setupViewModel() {
        
    }
}

extension PrayerTimeSelectionViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableCell.identifier, for: indexPath) as? BaseTableCell {
            cell.textLabel?.text = viewModel.textFor(item: item)
            cell.accessoryType = item == viewModel.selectedTime.value ? .checkmark : .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.row]
        
        // remove checkmark
        if let cell = tableView.cellForRow(at: viewModel.findIndexPath(viewModel.selectedTime.value)) {
            cell.accessoryType = .none
        }
        // add checkmark to selected cell
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        viewModel.selectedTime.value = item
    }
}
