//
//  Base.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit
//import GoogleMobileAds

// MARK: - Protocols
protocol ViewModel {}
protocol ViewModelItem {}

protocol ConfigurableController {
    func configure(viewModel: ViewModel)
}

protocol ConfigurableCell {
    func configure(viewModelItem: ViewModelItem)
}

// MARK: - ViewController
class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class BaseViewController: UIViewController {
    // MARK: - Views
//    var bannerView: GADBannerView!
//    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Receive memory warning from \(String(describing: self))")
    }
    
    func setupViews() {
        
    }
    
//    func addBannerView() {
//        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        NSLayoutConstraint.activate([
//            bannerView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
//            bannerView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
//            bannerView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor)
//            ])
//
//        bannerView.adUnitID = Constants.ADMOB.BANNER_UNIT_ID
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//    }
//
//    func createInterstitial() {
//        interstitial = GADInterstitial(adUnitID: Constants.ADMOB.INTERSTITIAL_UNIT_ID)
//        interstitial.delegate = self
//        interstitial.load(GADRequest())
//    }
//
//    func presentInterstitial() {
//        if interstitial.isReady {
//            interstitial.present(fromRootViewController: self)
//        } else {
//            print("Warning: Admob interstitial not ready at: \(String(describing: self))")
//        }
//    }
//
}

//extension BaseViewController: GADInterstitialDelegate {
//    // delegate method
//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        createInterstitial()
//    }
//}

class BaseTableViewController: UITableViewController {
    // MARK: - Views
//    var bannerView: GADBannerView!
//    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Receive memory warning from \(String(describing: self))")
    }
    
    func setupViews() {
        
    }
    
//    func addBannerView() {
//        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        NSLayoutConstraint.activate([
//            bannerView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
//            bannerView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
//            bannerView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor)
//            ])
//
//        bannerView.adUnitID = Constants.ADMOB.BANNER_UNIT_ID
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//    }
//
//    func createInterstitial() {
//        interstitial = GADInterstitial(adUnitID: Constants.ADMOB.INTERSTITIAL_UNIT_ID)
//        interstitial.delegate = self
//        interstitial.load(GADRequest())
//    }
//
//    func presentInterstitial() {
//        if interstitial.isReady {
//            interstitial.present(fromRootViewController: self)
//        } else {
//            print("Warning: Admob interstitial not ready at: \(String(describing: self))")
//        }
//    }
}

//extension BaseTableViewController: GADInterstitialDelegate {
//    // delegate method
//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        createInterstitial()
//    }
//}

class BaseCollectionViewController: UICollectionViewController {
    // MARK: - Views
//    var bannerView: GADBannerView!
//    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Receive memory warning from \(String(describing: self))")
    }
    
    func setupViews() {
        
    }
    
//    func addBannerView() {
//        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        NSLayoutConstraint.activate([
//            bannerView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
//            bannerView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
//            bannerView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor)
//            ])
//
//        bannerView.adUnitID = Constants.ADMOB.BANNER_UNIT_ID
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//    }
//
//    func createInterstitial() {
//        interstitial = GADInterstitial(adUnitID: Constants.ADMOB.INTERSTITIAL_UNIT_ID)
//        interstitial.delegate = self
//        interstitial.load(GADRequest())
//    }
//
//    func presentInterstitial() {
//        if interstitial.isReady {
//            interstitial.present(fromRootViewController: self)
//        } else {
//            print("Warning: Admob interstitial not ready at: \(String(describing: self))")
//        }
//    }
}

//extension BaseCollectionViewController: GADInterstitialDelegate {
//    // delegate method
//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        createInterstitial()
//    }
//}

// MARK: - Views
class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
}

class BaseTableCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

class BaseTableCellRightDetail: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

class BaseTableCellSubtitle: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

class BaseCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}


// MARK: - ViewModel
class BaseViewModel: NSObject, ViewModel {
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        
    }
}
