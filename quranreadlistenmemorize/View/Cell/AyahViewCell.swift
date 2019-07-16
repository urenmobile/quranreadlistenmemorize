//
//  AyahViewCell.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class AyahViewCell: BaseTableCell, ConfigurableCell {
    
    // MARK: - Variables
    var viewModelItem: AyahViewModelItem!
    
    private let padding: CGFloat = 20
    
    // MARK: - Views
    lazy var numberTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var numberDetailTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = UIColor.gray
        
        return label
    }()
    
    lazy var uthmaniTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .avaliableLargeTitle)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = self.frame.width
        label.textAlignment = .right
        return label
    }()
    
    lazy var transliterationTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline).italic()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = self.frame.width
        return label
    }()
    
    lazy var meaningTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = self.frame.width
        label.textColor = UIColor.gray
        return label
    }()
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        
        
        let cellStackView = UIStackView(arrangedSubviews: [numberTextLabel, uthmaniTextLabel, transliterationTextLabel, meaningTextLabel])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .vertical
        cellStackView.alignment = .fill
        cellStackView.distribution = .fill
        cellStackView.spacing = padding
        cellStackView.layoutMargins = UIEdgeInsets(top: padding/2, left: padding, bottom: padding, right: padding)
        cellStackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(numberDetailTextLabel)
        contentView.addSubview(cellStackView)
        NSLayoutConstraint.activate([
            cellStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            
            numberDetailTextLabel.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor, constant: padding/2),
            numberDetailTextLabel.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor, constant: -padding/2)
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        numberTextLabel.text = nil
        numberDetailTextLabel.text = nil
        uthmaniTextLabel.text = nil
        transliterationTextLabel.text = nil
        meaningTextLabel.text = nil
        
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? AyahViewModelItem else { return }
        self.viewModelItem = viewModelItem
        
        if let numberInSurah = viewModelItem.ayah.numberInSurah {
            numberTextLabel.text = "\(numberInSurah)"
        }
        
        uthmaniTextLabel.text = viewModelItem.uthmani
        transliterationTextLabel.text = viewModelItem.transliteration
        meaningTextLabel.text = viewModelItem.ayah.text
    }
    
    func detailConfigure(surah: Surah) {
        guard let viewModelItem = viewModelItem else { return }
        if let surahNumber = surah.number, let ayahNumber = viewModelItem.ayah.number {
            numberDetailTextLabel.text = "\(surahNumber):\(ayahNumber)"
        }
    }
}
