//
//  PrayerNotificationViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/21/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PrayerNotificationViewController: BaseTableViewController {
    
    // MARK: - Variables
    var viewModel: PrayerNotificationViewModel!
    
    // MARK: - Views
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        
        setupNavigation()
        setupTableView()
        setupViewModel()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = LocalizedConstants.Prayer.AlarmSettings
    }
    
    private func setupTableView() {
        tableView.register(PrayerNotificationViewCell.self, forCellReuseIdentifier: PrayerNotificationViewCell.identifier)
        tableView.register(BaseTableCellRightDetail.self, forCellReuseIdentifier: BaseTableCellRightDetail.identifier)
    }
    
    private func setupViewModel() {
        viewModel.getAlarms()
        viewModel.state.bindAndFire { [unowned self] in
            self.stateAnimate($0)
        }
    }
    
    func stateAnimate(_ state: State) {
        switch state {
        case .loading:
            startAnimating()
        case .populate:
            stopAnimating()
            reloadTableView()
        case .empty:
            stopAnimating()
            reloadTableView()
        case .error:
            stopAnimating()
        }
    }
    
    func startAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func reloadRow(_ indexPath: IndexPath) {
        tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

extension PrayerNotificationViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        if let item = item as? PrayerSoundSelectionViewModelItem {
            if let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableCellRightDetail.identifier, for: indexPath) as? BaseTableCellRightDetail {
                cell.imageView?.image = UIImage(named: Icon.speaker.rawValue)
                cell.textLabel?.text = LocalizedConstants.Prayer.AlarmSound
                cell.detailTextLabel?.text = item.titleText
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
        
        if let item = item as? PrayerNotificationViewModelItem {
            if let cell = tableView.dequeueReusableCell(withIdentifier: PrayerNotificationViewCell.identifier, for: indexPath) as? PrayerNotificationViewCell {
                cell.configure(viewModelItem: item)
                // when switch button change
                cell.valueChanged.bind { [unowned self] in
                    self.saveSwitchChange(prayerNotification: $0)
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleFor(section: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.section][indexPath.row]
        if let item = item as? PrayerSoundSelectionViewModelItem {
            pushSoundSelectionView(item: item, indexPath: indexPath)
        }
        
        if let item = item as? PrayerNotificationViewModelItem {
            pushAlarmSelectionView(item: item, indexPath: indexPath)
        }
    }
    
    private func pushSoundSelectionView(item: PrayerSoundSelectionViewModelItem, indexPath: IndexPath) {
        let prayerSoundSelectionVC = PrayerSoundSelectionViewController(style: .grouped)
        prayerSoundSelectionVC.viewModel = PrayerSoundSelectionViewModel()
        prayerSoundSelectionVC.viewModel.selectedSound.value = item.prayerSound
        prayerSoundSelectionVC.viewModel.selectedSound.bind { [unowned self] in
            item.prayerSound = $0
            self.reloadRow(indexPath)
            self.viewModel.changeSound(prayerSound: $0, section: indexPath.section)
        }
        
        self.navigationController?.pushViewController(prayerSoundSelectionVC, animated: true)
    }
    
    private func pushAlarmSelectionView(item: PrayerNotificationViewModelItem, indexPath: IndexPath) {
        guard item.isSelectable else { return }
        let prayerTimeSelectionViewController = PrayerTimeSelectionViewController(style: .grouped)
        prayerTimeSelectionViewController.viewModel = PrayerTimeSelectionViewModel()
        prayerTimeSelectionViewController.viewModel.selectedTime.value = Int(item.prayerNotification.minutesBefore)
        prayerTimeSelectionViewController.viewModel.selectedTime.bind { [unowned self] in
            item.prayerNotification.minutesBefore = Int16($0)
            self.navigationController?.popViewController(animated: true)
            self.reloadRow(indexPath)
            self.viewModel.updateDataAndScheduleNotification()
        }
        
        self.navigationController?.pushViewController(prayerTimeSelectionViewController, animated: true)
    }
    
    private func saveSwitchChange(prayerNotification: PrayerNotificationMO) {
        // when off not call
        if prayerNotification.status {
            NotificationManager.shared.requestAuthorization(self)
        }
        viewModel.updateDataAndScheduleNotification()
    }
}
