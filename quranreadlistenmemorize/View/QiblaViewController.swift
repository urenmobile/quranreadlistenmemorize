//
//  QiblaViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/22/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import CoreLocation

class QiblaViewController: BaseViewController {
    
    var backgroundColor = UIColor.white
    
    let indicatorView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    let outerImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "compass_degree")
        return imageView
    }()
    
    let innerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "qaaba")
        return imageView
    }()
    
    let yourLocation = CLLocation(latitude: 90, longitude: 0) // default value is North Pole (lat: 90, long: 0) }
    
    var latestLocation: CLLocation? = nil
    var yourLocationBearing: CGFloat {
        return latestLocation?.bearingToLocationRadian(self.yourLocation) ?? 0
    }
    
    private func orientationAdjustment() -> CGFloat {
        let isFaceDown: Bool = {
            switch UIDevice.current.orientation {
            case .faceDown: return true
            default: return false
            }
        }()
        
        let adjAngle: CGFloat = {
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:  return 90
            case .landscapeRight: return -90
            case .portrait, .unknown: return 0
            case .portraitUpsideDown: return isFaceDown ? 180 : -180
            }
        }()
        return adjAngle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LocationManager.shared.stopUpdateLocation()
        Utility.lockOrientation(.allButUpsideDown)
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.backgroundColor = backgroundColor
        
        setupLocation()
        
        view.addSubview(indicatorView)
        view.addSubview(outerImageView)
        view.addSubview(innerImageView)
        
        NSLayoutConstraint.activate([
            indicatorView.safeBottomAnchor.constraint(equalTo: outerImageView.safeTopAnchor, constant: -10),
            indicatorView.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            indicatorView.safeWidthAnchor.constraint(equalToConstant: 5),
            indicatorView.safeHeightAnchor.constraint(equalToConstant: 20),
            
            outerImageView.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            outerImageView.safeCenterYAnchor.constraint(equalTo: view.safeCenterYAnchor),
            outerImageView.safeWidthAnchor.constraint(lessThanOrEqualTo: view.safeWidthAnchor, multiplier: 1),
            outerImageView.safeHeightAnchor.constraint(lessThanOrEqualTo: view.safeHeightAnchor, multiplier: 1),
            outerImageView.safeWidthAnchor.constraint(equalTo: outerImageView.safeHeightAnchor, multiplier: 1),
            
            innerImageView.safeCenterXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            innerImageView.safeCenterYAnchor.constraint(equalTo: view.safeCenterYAnchor),
            innerImageView.safeWidthAnchor.constraint(lessThanOrEqualTo: outerImageView.safeWidthAnchor, multiplier: 0.3),
            innerImageView.safeHeightAnchor.constraint(lessThanOrEqualTo: outerImageView.safeHeightAnchor, multiplier: 0.3),
            innerImageView.safeWidthAnchor.constraint(equalTo: innerImageView.safeHeightAnchor, multiplier: 1),
            ])
    }
    
    private func setupLocation() {
        LocationManager.shared.requestAuthorization(self)
        LocationManager.shared.startUpdateLocation()
        
        LocationManager.shared.locationCallback = { location in
            self.latestLocation = location
        }
        
        LocationManager.shared.headingCallback = { newHeading in
            UIView.animate(withDuration: 0.5) {
                let angle = computeNewAngle(with: CGFloat(newHeading))
                self.outerImageView.transform = CGAffineTransform(rotationAngle: angle)
            }
            
            func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
                
                let heading: CGFloat = {
                    let originalHeading = self.yourLocationBearing - newAngle.degreesToRadians
                    switch UIDevice.current.orientation {
                    case .faceDown: return -originalHeading
                    default: return originalHeading
                    }
                }()
                
                if newAngle >= 150 && newAngle <= 152 {
                    self.view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                } else {
                    self.view.backgroundColor = self.backgroundColor
                }
                
                return CGFloat(self.orientationAdjustment().degreesToRadians + heading)
            }
            
        }
        
    }
}
