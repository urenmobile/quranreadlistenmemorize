//
//  EditionViewEditionCell.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/13/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class EditionViewEditionCell1: BaseTableCellSubtitle, ConfigurableCell {
    var viewModelItem: EditionViewModelItem!
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? EditionViewModelItem else { return }
        self.viewModelItem = viewModelItem
        
        textLabel?.text = viewModelItem.edition.name + " (\(viewModelItem.languageName))"
        detailTextLabel?.text = viewModelItem.edition.englishName
    }
}


class EditionViewEditionCell: BaseTableCell, ConfigurableCell {
    // MARK: - Variables
    var viewModelItem: EditionViewModelItem!
    
    private let padding: CGFloat = 8
    
    // MARK: - Views
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 1
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 1
        return label
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    let progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.text = LocalizedConstants.Downloading + "..."
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showHideProgress(false)
    }
    
    override func setupViews() {
        super.setupViews()
        
        let progresStackView = UIStackView(arrangedSubviews: [progressView, progressLabel])
        progresStackView.alignment = .center
        progresStackView.distribution = .fill
        progresStackView.spacing = padding
        
        let cellStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, progresStackView])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .vertical
        cellStackView.alignment = .fill
        cellStackView.distribution = .fill
        cellStackView.spacing = padding
        cellStackView.layoutMargins = UIEdgeInsets(top: padding, left: 2*padding, bottom: padding, right: 2*padding)
        cellStackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(cellStackView)
        NSLayoutConstraint.activate([
            cellStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            ])
        showHideProgress(false)
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? EditionViewModelItem else { return }
        self.viewModelItem = viewModelItem
        
        titleLabel.text = viewModelItem.edition.englishName
        subtitleLabel.text = viewModelItem.edition.name
        showHideProgress(viewModelItem.isDownloading)
    }
    
    func updateProgress(totalSize: String, progress: Float) {
        DispatchQueue.main.async {
            self.progressView.progress = progress
            self.progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
        }
    }
    
    func showHideProgress(_ show: Bool) {
        progressView.isHidden = !show
        progressLabel.isHidden = !show
    }
}

