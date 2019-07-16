//
//  PrayerTimeViewCell.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/16/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class PrayerTimeViewCellTimer: BaseTableCell, ConfigurableCell {
    
    // MARK: - Variables
    var viewModelItem: PrayerTimerViewModelItemTimer!
    var countdownTimer: Timer?
    
    private let padding: CGFloat = 20
    private let titleFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
    private let titleTextColor = UIColor.black

    // MARK: - Views
    lazy var currentDateTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        label.numberOfLines = 1
        label.textColor = titleTextColor
        return label
    }()
    
    lazy var hijriDateTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout)
        label.numberOfLines = 1
        label.textColor = titleTextColor
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
        label.numberOfLines = 1
        label.textColor = titleTextColor
        label.text = LocalizedConstants.Prayer.RemainingTime
        return label
    }()
    
    lazy var prayerTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .avaliableLargeTitle)
        label.numberOfLines = 1
        label.textColor = titleTextColor
        label.text = " "
        return label
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .avaliableLargeTitle)
        label.numberOfLines = 1
        label.textColor = titleTextColor
        label.text =  "        " // "00:00:00"
        return label
    }()
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        
        let cellStackView = UIStackView(arrangedSubviews: [currentDateTextLabel, hijriDateTextLabel, titleLabel, prayerTimeLabel, timerLabel])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .vertical
        cellStackView.alignment = .center
        cellStackView.distribution = .fill
        cellStackView.spacing = padding/2
        cellStackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        cellStackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(cellStackView)
        NSLayoutConstraint.activate([
            cellStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            ])
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? PrayerTimerViewModelItemTimer else { return }
        self.viewModelItem = viewModelItem
        
        currentDateTextLabel.text = Formatter.shared.dateTextFormatter.string(from: Date())
        hijriDateTextLabel.text = viewModelItem.prayerTime?.hijriDateString
        
        updateTimer()
    }
    
    @objc func updateTimer() {
        // Use the configured formatter to generate the string.
        if let prayerTimeType = viewModelItem.findNearestPrayerTimeType() {
            prayerTimeLabel.text = prayerTimeType.localizedString()
        } else {
            prayerTimeLabel.text = PrayerTimeType.fajr.localizedString()
        }
        let timeInterval = viewModelItem.findNearestPrayerTimeInterval()
        timerLabel.text = Formatter.shared.dateComponentFormatter.string(from: timeInterval)
    }
}

class PrayerTimeViewCell: BaseTableCell, ConfigurableCell {
    // MARK: - Variables
    var viewModelItem: PrayerTimeViewModelItem!
    
    private let padding: CGFloat = 20
    private let titleFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
    private let timeFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout)
    private let timeTextColor = UIColor.black.withAlphaComponent(0.7)
        
    // MARK: - Views
    lazy var gregorianDateTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.preferredMaxLayoutWidth = self.frame.width
        return label
    }()
    
    // MARK: - Views
    lazy var hijriDateTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 1
        label.preferredMaxLayoutWidth = self.frame.width
        return label
    }()
    
    // Fajr
    lazy var fajrTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = titleFont
        label.numberOfLines = 1
        label.text = LocalizedConstants.Prayer.Fajr
        return label
    }()
    
    lazy var fajrTimeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = timeFont
        label.numberOfLines = 1
        label.preferredMaxLayoutWidth = self.frame.width
        label.textColor = timeTextColor
        return label
    }()
    
    // Sunrise
    lazy var sunriseTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = titleFont
        label.numberOfLines = 1
        label.text = LocalizedConstants.Prayer.Sunrise
        return label
    }()
    
    lazy var sunriseTimeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = timeFont
        label.numberOfLines = 1
        label.preferredMaxLayoutWidth = self.frame.width
        label.textColor = timeTextColor
        return label
    }()
    
    // Dhuhr
    lazy var dhuhrTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = titleFont
        label.numberOfLines = 1
        label.text = LocalizedConstants.Prayer.Dhuhr
        return label
    }()
    
    lazy var dhuhrTimeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = timeFont
        label.numberOfLines = 1
        label.preferredMaxLayoutWidth = self.frame.width
        label.textColor = timeTextColor
        return label
    }()
    
    // Asr
    lazy var asrTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = titleFont
        label.numberOfLines = 1
        label.text = LocalizedConstants.Prayer.Asr
        return label
    }()
    
    lazy var asrTimeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = timeFont
        label.numberOfLines = 1
        label.preferredMaxLayoutWidth = self.frame.width
        label.textColor = timeTextColor
        return label
    }()
    
    // Maghrib
    lazy var maghribTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = titleFont
        label.numberOfLines = 1
        label.text = LocalizedConstants.Prayer.Maghrib
        return label
    }()
    
    lazy var maghribTimeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = timeFont
        label.numberOfLines = 1
        label.preferredMaxLayoutWidth = self.frame.width
        label.textColor = timeTextColor
        return label
    }()
    
    // Isha
    lazy var ishaTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = titleFont
        label.numberOfLines = 1
        label.text = LocalizedConstants.Prayer.Isha
        return label
    }()
    
    lazy var ishaTimeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = timeFont
        label.numberOfLines = 1
        label.preferredMaxLayoutWidth = self.frame.width
        label.textColor = timeTextColor
        return label
    }()
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        
        let fajrStack = createStack(fajrTitleLabel, fajrTimeTextLabel)
        let sunriseStack = createStack(sunriseTitleLabel, sunriseTimeTextLabel)
        let dhuhrStack = createStack(dhuhrTitleLabel, dhuhrTimeTextLabel)
        let asrStack = createStack(asrTitleLabel, asrTimeTextLabel)
        let maghribStack = createStack(maghribTitleLabel, maghribTimeTextLabel)
        let ishaStack = createStack(ishaTitleLabel, ishaTimeTextLabel)
        
        let timeStackView = UIStackView(arrangedSubviews: [fajrStack, sunriseStack, dhuhrStack, asrStack, maghribStack, ishaStack])
        timeStackView.alignment = .fill
        timeStackView.distribution = .fillEqually
        
        let dateStackView = UIStackView(arrangedSubviews: [gregorianDateTextLabel, hijriDateTextLabel])
        dateStackView.distribution = .equalCentering
        
        let cellStackView = UIStackView(arrangedSubviews: [dateStackView, timeStackView])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .vertical
        cellStackView.alignment = .fill
        cellStackView.distribution = .fill
        cellStackView.spacing = padding
        cellStackView.layoutMargins = UIEdgeInsets(top: padding/2, left: padding/2, bottom: padding, right: padding/2)
        cellStackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(cellStackView)
        NSLayoutConstraint.activate([
            cellStackView.safeTopAnchor.constraint(equalTo: contentView.safeTopAnchor),
            cellStackView.safeBottomAnchor.constraint(equalTo: contentView.safeBottomAnchor),
            cellStackView.safeLeadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor),
            cellStackView.safeTrailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor),
            ])
    }
    
    private func createStack(_ firstLabel: UILabel, _ secondLabel: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = padding / 2
        return stackView
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? PrayerTimeViewModelItem else { return }
        self.viewModelItem = viewModelItem
        
        let prayerTime = viewModelItem.prayerTime
        
        gregorianDateTextLabel.text = Formatter.shared.dateFormatter.string(from: prayerTime.gregorianDate)
        hijriDateTextLabel.text = prayerTime.hijriDateString
        
        fajrTimeTextLabel.text = timeString(prayerTime.fajrDate)
        sunriseTimeTextLabel.text = timeString(prayerTime.sunriseDate)
        dhuhrTimeTextLabel.text = timeString(prayerTime.dhuhrDate)
        asrTimeTextLabel.text = timeString(prayerTime.asrDate)
        maghribTimeTextLabel.text = timeString(prayerTime.maghribDate)
        ishaTimeTextLabel.text = timeString(prayerTime.ishaDate)
    }
    
    private func timeString(_ date: Date) -> String {
        return Formatter.shared.hourMinuteDateFormatter.string(from: date)
    }
}

class PrayerTimeViewCellToday: BaseTableCellRightDetail, ConfigurableCell {
    // MARK: - Variables
    var viewModelItem: PrayerTimeViewModelItemToday!
    
    private let padding: CGFloat = 10
    private let titleFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    private let timeFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
    private let timeTextColor = UIColor.black.withAlphaComponent(0.6)
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
    }
    
    func configure(viewModelItem: ViewModelItem) {
        guard let viewModelItem = viewModelItem as? PrayerTimeViewModelItemToday else { return }
        self.viewModelItem = viewModelItem
        
        imageView?.image = UIImage(named: viewModelItem.type.iconName())
        
        textLabel?.text = viewModelItem.type.localizedString()
        detailTextLabel?.text = viewModelItem.timeText()
    }
    
    
}
