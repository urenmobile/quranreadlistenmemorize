//
//  PrayerLocationViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/15/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PrayerLocationViewController: BaseTableViewController {
    
    // MARK: - Variables
    var viewModel: PrayerLocationViewModel!
    
    // MARK: - Views
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        
        return activityIndicatorView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        
        return searchController
    }()
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        
        setupNavigation()
        setupTableView()
        setupViewModel()
    }
    
    func setupNavigation() {
        self.navigationController?.title = viewModel.title
        
        // by setting definesPresentationContext on your view controller to true, you ensure that the search bar does not remain on the screen if the user navigates to another view controller while the UISearchController is active.
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
    }
    
    func setupTableView() {
        tableView.keyboardDismissMode = .interactive
        
        tableView.register(BaseTableCellSubtitle.self, forCellReuseIdentifier: BaseTableCellSubtitle.identifier)
        
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            activityIndicatorView.safeCenterYAnchor.constraint(equalTo: view.safeCenterYAnchor),
            ])
    }
    
    deinit {
        viewModel.state.unbind()
    }
    
    func setupViewModel() {
        viewModel.getData()
        viewModel.state.bindAndFire { [unowned self] in
            self.stateAnimate($0)
        }
    }
    
    func stateAnimate(_ state: State) {
        switch state {
        case .loading:
            activityIndicatorView.startAnimating()
            reloadTableView()
        case .populate:
            activityIndicatorView.stopAnimating()
            reloadTableView()
        case .empty:
            activityIndicatorView.stopAnimating()
        case .error:
            activityIndicatorView.stopAnimating()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension PrayerLocationViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.filteredItems[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableCellSubtitle.identifier, for: indexPath) as? BaseTableCellSubtitle {
            cell.textLabel?.text = item.nameText
            cell.detailTextLabel?.text = item.detailNameText
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.filteredItems[indexPath.row]
        viewModel.completion?(item)
    }
}

extension PrayerLocationViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate  {
    
    public func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        viewModel.search(text: searchString)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
