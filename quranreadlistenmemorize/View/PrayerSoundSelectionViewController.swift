//
//  PrayerSoundSelectionViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 3/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PrayerSoundSelectionViewController: BaseTableViewController {
    
    var viewModel: PrayerSoundSelectionViewModel!
    
    override func setupViews() {
        super.setupViews()
        
        setupNavigation()
        setupTableView()
        setupViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SoundPlayManager.shared.stopSound()
    }
    
    func setupNavigation() {
        
    }
    
    func setupTableView() {
        tableView.register(BaseTableCell.self, forCellReuseIdentifier: BaseTableCell.identifier)
    }
    
    private func setupViewModel() {
        viewModel.getSounds()
    }
}

extension PrayerSoundSelectionViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableCell.identifier, for: indexPath) as? BaseTableCell {
            cell.textLabel?.text = item.titleText
            cell.accessoryType = item.prayerSound == viewModel.selectedSound.value ? .checkmark : .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: viewModel.findIndexPath(viewModel.selectedSound.value)) {
            cell.accessoryType = .none
        }
        // add checkmark to selected cell
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        SoundPlayManager.shared.playSound(name: item.prayerSound.name)
        viewModel.selectedSound.value = item.prayerSound
    }
}
