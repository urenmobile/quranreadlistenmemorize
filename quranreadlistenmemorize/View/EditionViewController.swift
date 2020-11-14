//
//  EditionViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class EditionViewController: BaseTableViewController {
    
    // MARK: - Variables
    var viewModel: EditionViewModel!
    
    // MARK: - Views
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        
        setupNavigation()
        setupTableView()
        setupViewModel()
    }
    
    func setupNavigation() {
        self.navigationItem.title = LocalizedConstants.Edition.SelectTranslation
    }
    
    func setupTableView() {
        tableView.register(EditionViewEditionCell.self, forCellReuseIdentifier: EditionViewEditionCell.identifier)
    }
    
    func setupViewModel() {
        viewModel.getEditions()
        viewModel.state.bindAndFire { [unowned self](_) in
            self.reloadTableView()
            self.scrollToSelectedItem()
        }
        
        viewModel.downloadCompletion = { [weak self]  in
            switch $0 {
            case .progress(let written, let expected, let progress):
                self?.progressDownload(written, expected, progress)
            case .success(let tuple):
                let destinationUrl = FileOperationManager.shared.localJsonFilePath(for: tuple.sourceUrl)
                FileOperationManager.shared.copyFile(from: tuple.location, to: destinationUrl)
                self?.finishDownload()
            case .failure(let apiError):
                debugPrint("Error oldu: \(apiError)")
            }
            
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func scrollToSelectedItem() {
        if !viewModel.items.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let indexPath = self.viewModel.findSelectedIndexPath()
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
}


extension EditionViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: EditionViewEditionCell.identifier, for: indexPath) as? EditionViewEditionCell {
            cell.configure(viewModelItem: item)
            
            cell.accessoryType = .none
            if item.edition == viewModel.selectedEdition {
                cell.accessoryType = .checkmark
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.items[section].first?.languageName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.section][indexPath.row]
        
        if let willDownloadItem = viewModel.willDownloadItem, willDownloadItem.isDownloading {
            showDownloadContinueAlert()
        } else if item.downloaded || item.isBundleFile {
            viewModel.selectedEdition = item.edition
            reloadTableView()
        } else if !item.isDownloading {
            viewModel.willDownloadItem = item
            showDownloadAlert()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showDownloadContinueAlert() {
        let alerController = UIAlertController(title: LocalizedConstants.Downloading, message: LocalizedConstants.Edition.DownloadContinueTranslationMessage, preferredStyle: .alert)
        
        alerController.addAction(
            UIAlertAction(title: LocalizedConstants.Ok, style: .default) { (_) in
                alerController.dismiss(animated: true, completion: nil)
            }
        )
        self.present(alerController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            alerController.dismiss(animated: true, completion: nil)
        }
    }
    
    func showDownloadAlert() {
        let alerController = UIAlertController(title: LocalizedConstants.Download, message: LocalizedConstants.Edition.DownloadTranslationMessage, preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: LocalizedConstants.Cancel, style: .cancel, handler: nil)
        
        let actionOk = UIAlertAction(title: LocalizedConstants.Ok, style: .default) { (_) in
            self.startDownload()
        }
        
        alerController.addAction(actionCancel)
        alerController.addAction(actionOk)
        
        self.present(alerController, animated: true, completion: nil)
    }
    
    func startDownload() {
        viewModel.downloadEdition(identifier: viewModel.willDownloadItem.edition.identifier)
        reloadRow(viewModel.indexPathFor(viewModel.willDownloadItem))
    }
    
    private func progressDownload(_ written: String, _ expected: String, _ progress: Float) {
        let willDownloadIndexPath = viewModel.indexPathFor(viewModel.willDownloadItem)
        if let cell = self.tableView.cellForRow(at: willDownloadIndexPath) as? EditionViewEditionCell {
            cell.updateProgress(totalSize: expected, progress: progress)
        }
    }
    
    private func finishDownload() {
        viewModel.willDownloadItem.isDownloading = false
        viewModel.selectedEdition = viewModel.willDownloadItem.edition
        tableView.visibleCells.forEach({ $0.accessoryType = .none})
        reloadRow(viewModel.indexPathFor(viewModel.willDownloadItem))
    }
    
    func reloadRow(_ indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
