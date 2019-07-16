//
//  SurahViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class SurahViewController: BaseTableViewController {
    // MARK: - Variables
    var viewModel: SurahViewModel!
    
    let icon = UIImage(named: Icon.quran.rawValue)
    let iconTitle = LocalizedConstants.Surah.Quran
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedConstants.Edition.Translations, style: .plain, target: self, action: #selector(pushEditionsViewController))
        self.navigationItem.title = iconTitle
    }
    
    @objc func pushEditionsViewController() {
        let editionViewController = EditionViewController(style: .grouped)
        editionViewController.viewModel = EditionViewModel()
        editionViewController.viewModel.isEditionChanged.bind { [weak self](_) in
            self?.viewModel.getSelectedQuranEdition()
        }
        self.navigationController?.pushViewController(editionViewController, animated: true)
    }
    
    func setupTableView() {
        tableView.register(BaseTableCellRightDetail.self, forCellReuseIdentifier: BaseTableCellRightDetail.identifier)
        
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            activityIndicatorView.safeCenterYAnchor.constraint(equalTo: view.safeCenterYAnchor),
            ])
    }
    
    func setupViewModel() {
        viewModel.getSelectedQuranEdition()
        bindViewModel()
    }
    
    deinit {
        viewModel.state.unbind()
    }
    
    func bindViewModel() {
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
    
}

extension SurahViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableCellRightDetail.identifier, for: indexPath) as? BaseTableCellRightDetail {
            
            cell.textLabel?.text = item.surahText
            if let ayahs = item.surah.ayahs {
                cell.detailTextLabel?.text = "\(ayahs.count)"
            }
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitleFor(section: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        let ayahViewController = AyahViewController(style: .grouped)
        ayahViewController.navigationItem.title = item.surahTitleName
        ayahViewController.viewModel = AyahViewModel(surah: item.surah)
        
        self.navigationController?.pushViewController(ayahViewController, animated: true)
    }
}
