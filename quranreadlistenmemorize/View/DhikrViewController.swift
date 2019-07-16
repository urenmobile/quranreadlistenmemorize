//
//  DhikrViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/19/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class DhikrViewController: BaseTableViewController {
    
    // MARK: - Variables
    var viewModel: DhikrViewModel!
    
    // MARK: - Views
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupNavigation()
        setupTableView()
        setupViewModel()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = MoreViewModelItemType.dhikr.localized()
    }
    
    private func setupTableView() {
        tableView.register(BaseTableCellRightDetail.self, forCellReuseIdentifier: BaseTableCellRightDetail.identifier)
        
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            activityIndicatorView.safeCenterYAnchor.constraint(equalTo: view.safeCenterYAnchor),
            ])
    }
    
    private func setupViewModel() {
        viewModel.getDhikrs()
        viewModel.state.bindAndFire { [unowned self] in
            self.stateAnimate($0)
        }
    }
    
    private func stateAnimate(_ state: State) {
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

extension DhikrViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableCellRightDetail.identifier, for: indexPath) as? BaseTableCellRightDetail {
            cell.textLabel?.text = item.dhikr.name
            cell.detailTextLabel?.text = "\(item.dhikr.totalCount)"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        let dhikrDetailViewModel = DhikrDetailViewModel(dhikr: item.dhikr)
        let dhikrDetailViewController = DhikrDetailViewController()
        dhikrDetailViewController.viewModel = dhikrDetailViewModel
        self.navigationController?.pushViewController(dhikrDetailViewController, animated: true)
    }
}
