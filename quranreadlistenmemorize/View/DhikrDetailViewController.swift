//
//  DhikrDetailViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/18/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class DhikrDetailViewController: BaseViewController {
    
    // MARK: - Variables
    var viewModel: DhikrDetailViewModel!
    
    private let padding: CGFloat = 10
    private let circleLineWidth: CGFloat = 20
    private let circleTrackColor = UIColor.lightGray.cgColor
    private let circleShapeColor = UIColor.green.withAlphaComponent(0.5).cgColor
    private let strokeEndAnimationKey = "strokeEnd"
    private let circleViewMultiple: CGFloat = 0.8
    
    // MARK: - Views
    lazy var soundSwitchBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: Icon.speaker.rawValue), style: .done, target: self, action: #selector(soundSwitch))
        barButtonItem.landscapeImagePhone = UIImage(named: Icon.speakerLandscape.rawValue)
        return barButtonItem
    }()
    
    lazy var prayerTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isEditable = false
        textView.backgroundColor = UIColor.white
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    lazy var circleView: CircleView = {
        let width = self.view.frame.width * circleViewMultiple
        let circleSize = CGSize(width: width, height: width)
        
        let circleView = CircleView(frame: CGRect(origin: .zero, size: circleSize))
        circleView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        
        circleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCountDownAction)))
        return circleView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circleView)
        return view
    }()
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        setupNavigation()
        
        updateUI()
        animateCircle(fromValue: viewModel.startValue, toValue: viewModel.startValue)
        
        view.addSubview(prayerTextView)
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            prayerTextView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: padding),
            prayerTextView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: padding),
            prayerTextView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -padding),
            prayerTextView.safeHeightAnchor.constraint(equalTo: view.safeHeightAnchor, multiplier: 0.2),
            
            containerView.safeTopAnchor.constraint(equalTo: prayerTextView.bottomAnchor, constant: 2*padding),
            containerView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            containerView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            containerView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            ])
    }
    
    func setupNavigation() {
        self.navigationItem.title = viewModel.dhikr.name
        let refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetCount))
        self.navigationItem.rightBarButtonItems = [soundSwitchBarButtonItem, refreshBarButtonItem]
        updateSoundSwitchButtonTintColor()
    }
    
    @objc func soundSwitch() {
        viewModel.changeSoundOnOff()
        updateSoundSwitchButtonTintColor()
    }
    
    private func updateSoundSwitchButtonTintColor() {
        soundSwitchBarButtonItem.tintColor = viewModel.dhikr.isSoundOn ? view.tintColor : UIColor.lightGray
    }
    
    @objc func resetCount() {
        showResetAlert()
    }
    
    func showResetAlert() {
        let alertController = UIAlertController(title: LocalizedConstants.Warning, message: LocalizedConstants.More.MoreDhikrReset, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: LocalizedConstants.No, style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: LocalizedConstants.Yes, style: .default) { (_) in
            self.viewModel.reset()
            self.resetAnimation()
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func tapCountDownAction() {
        animateCircle(fromValue: viewModel.startValue, toValue: viewModel.endValue)
        viewModel.updateCountDown()
        
        SoundPlayManager.shared.playKeyPressedSound(isSoundOn: viewModel.dhikr.isSoundOn)
        if viewModel.checkCounterRestart() {
            animateCircle(fromValue: viewModel.maxValue, toValue: viewModel.maxValue)
            SoundPlayManager.shared.playScreenLockSound(isSoundOn: viewModel.dhikr.isSoundOn)
        }
        updateUI()
    }
    
    private func resetAnimation() {
        updateUI()
        animateCircle(fromValue: viewModel.startValue, toValue: viewModel.startValue)
    }
    
    private func animateCircle(fromValue: Double, toValue: Double) {
        let basicAnimation = CABasicAnimation(keyPath: strokeEndAnimationKey)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.fromValue = fromValue
        basicAnimation.toValue = toValue
        
        circleView.shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    private func updateUI() {
        circleView.countTextLabel.text = "\(viewModel.dhikr.remainingCount)"
        circleView.roundCountTextLabel.text = "\(viewModel.dhikr.roundCount)"
        prayerTextView.text = viewModel.dhikr.reading
    }
}


class CircleView: BaseView {
    
    // MARK: - Variables
    private let circleLineWidth: CGFloat = 20
    private let circleTrackColor = UIColor.gray.cgColor
    private let circleShapeColor = UIColor.green.withAlphaComponent(0.5).cgColor
    private let strokeEndAnimationKey = "strokeEnd"
    
    let shapeLayer = CAShapeLayer()
    
    // MARK: - Views
    let roundCountTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 1
        return label
    }()
    
    let countTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .avaliableLargeTitle)
        label.numberOfLines = 1
        return label
    }()
    
    
    // MARK: - Functions
    override func setupViews() {
        super.setupViews()
        
        let radius = frame.width / 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = 3 * CGFloat.pi / 2
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circlePath.cgPath
        trackLayer.strokeColor = circleTrackColor
        trackLayer.lineWidth = circleLineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeEnd = 1
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = circleShapeColor
        shapeLayer.lineWidth = circleLineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(shapeLayer)
        
        addSubview(roundCountTextLabel)
        addSubview(countTextLabel)
        NSLayoutConstraint.activate([
            roundCountTextLabel.safeTopAnchor.constraint(equalTo: safeTopAnchor),
            roundCountTextLabel.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor),
            
            countTextLabel.safeCenterXAnchor.constraint(equalTo: safeCenterXAnchor),
            countTextLabel.safeCenterYAnchor.constraint(equalTo: safeCenterYAnchor),
            ])
    }
}
