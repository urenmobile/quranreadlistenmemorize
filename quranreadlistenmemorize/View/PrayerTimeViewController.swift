//
//  PrayerTimeViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PrayerTimeViewController: BaseTableViewController {
    // MARK: - Variables
    var viewModel: PrayerTimeViewModel!
    private var countdownTimer: Timer?
    
    // MARK: - Views
    let icon = UIImage(named: Icon.prayerTimes.rawValue)
    let iconTitle = LocalizedConstants.Prayer.PrayerTimes
    
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
    
    func setupNavigation() {
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedConstants.Prayer.SetAlarm, style: .plain, target: self, action: #selector(pushAlarmNotificationSetting))
        self.navigationItem.title = iconTitle
        
        navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func setupTableView() {
        tableView.register(BaseTableCellSubtitle.self, forCellReuseIdentifier: BaseTableCellSubtitle.identifier)
        tableView.register(PrayerTimeViewCell.self, forCellReuseIdentifier: PrayerTimeViewCell.identifier)
        tableView.register(PrayerTimeViewCellToday.self, forCellReuseIdentifier: PrayerTimeViewCellToday.identifier)
        tableView.register(PrayerTimeViewCellTimer.self, forCellReuseIdentifier: PrayerTimeViewCellTimer.identifier)
        
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            activityIndicatorView.safeCenterYAnchor.constraint(equalTo: view.safeCenterYAnchor),
            ])
        
    }
    
    func setupViewModel() {
        viewModel.getPrayerTimes()
        
        viewModel.state.bind { [unowned self] in
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
    
    @objc func pushAlarmNotificationSetting() {
        let prayerTimeAlarmViewController = PrayerNotificationViewController(style: .grouped)
        prayerTimeAlarmViewController.viewModel = PrayerNotificationViewModel()
        self.navigationController?.pushViewController(prayerTimeAlarmViewController, animated: true)
    }
}

extension PrayerTimeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        if let item = item as? PrayerTimeViewModelItemLocation {
            if let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableCellSubtitle.identifier, for: indexPath) as? BaseTableCellSubtitle {
                cell.imageView?.image = UIImage(named: Icon.place.rawValue)
                cell.textLabel?.text = item.locationTitleText()
                cell.detailTextLabel?.text = item.locationSubTitleText()
                cell.accessoryType = .disclosureIndicator
                
                return cell
            }
        }
        
        if let item = item as? PrayerTimerViewModelItemTimer {
            if let cell = tableView.dequeueReusableCell(withIdentifier: PrayerTimeViewCellTimer.identifier, for: indexPath) as? PrayerTimeViewCellTimer {
                cell.configure(viewModelItem: item)
                cell.selectionStyle = .none
                
                countdownTimer?.invalidate()
                countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                    cell.updateTimer()
                })
                if let countdownTimer = countdownTimer {
                    // if the timer did't add runlopp then stop timer when scroll
                    RunLoop.current.add(countdownTimer, forMode: RunLoop.Mode.common)
                }
                
                return cell
            }
        }
        
        if let item = item as? PrayerTimeViewModelItemToday {
            if let cell = tableView.dequeueReusableCell(withIdentifier: PrayerTimeViewCellToday.identifier, for: indexPath) as? PrayerTimeViewCellToday {
                cell.configure(viewModelItem: item)
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: PrayerTimeViewCell.identifier, for: indexPath) as? PrayerTimeViewCell {
            cell.configure(viewModelItem: item)
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitleFor(section: section)
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.footerTitleFor(section: section)
    }
    
    // edit action
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath == IndexPath(row: 0, section: viewModel.locationSection)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            countdownTimer?.invalidate()
            viewModel.removeLocationAndPrayerTimes()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        if item is PrayerTimeViewModelItemLocation {
            pushLocationCountrySelectionViewController()
        }
        
        if item is PrayerTimeViewModelItemToday {
            pushAlarmNotificationSetting()
        }
    }
    
    func pushLocationCountrySelectionViewController() {
        let countriesViewController = PrayerLocationViewController()
        countriesViewController.viewModel = PrayerLocationCountriesViewModel()
        self.navigationController?.pushViewController(countriesViewController, animated: true)
        countriesViewController.viewModel.completion = { [unowned self] in
            self.viewModel.selectedCountry = $0
            self.pushLocationCitySelectionViewController()
        }
    }
    
    func pushLocationCitySelectionViewController() {
        guard let selectedCountry = viewModel.selectedCountry else { return }
        
        let citiesViewController = PrayerLocationViewController()
        citiesViewController.viewModel = PrayerLocationCitiesViewModel(selectedCountry)
        self.navigationController?.pushViewController(citiesViewController, animated: true)
        citiesViewController.viewModel.completion = { [unowned self] in
            self.viewModel.selectedCity = $0
            self.pushLocationCountySelectionViewController()
        }
    }
    
    func pushLocationCountySelectionViewController() {
        guard let selectedCity = viewModel.selectedCity else { return }
        
        let countiesViewController = PrayerLocationViewController()
        countiesViewController.viewModel = PrayerLocationCountiesViewModel(selectedCity)
        self.navigationController?.pushViewController(countiesViewController, animated: true)
        countiesViewController.viewModel.completion = { [unowned self] in
            self.viewModel.selectedCounty = $0
            self.navigationController?.popToRootViewController(animated: true)
            self.viewModel.saveAndGetPrayerTimes()
        }
    }
}
