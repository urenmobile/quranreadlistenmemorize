//
//  HolyDayMessageViewController.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/22/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit

class HolyDayMessageViewController: BaseViewController {
    
    private var documentInteractionController = UIDocumentInteractionController()
    private let templateImageArray : [UIImage] = [UIImage(named: "1.jpg")!, UIImage(named: "2.jpg")!, UIImage(named: "3.jpg")!, UIImage(named: "4.jpg")!, UIImage(named: "5.jpg")!]
    private var activeIndex : Int = 0
    
    lazy var leftButton: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: Icon.back.rawValue)
        temp.tintColor = UIColor.white
        return temp
    }()
    
    lazy var rigthButton: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.image = UIImage(named: Icon.forward.rawValue)
        temp.tintColor = UIColor.white
        return temp
    }()
    
    lazy var imageContainer: UIImageView = {
        let temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isUserInteractionEnabled = true
        temp.contentMode = .scaleAspectFit
        temp.image = templateImageArray.first
        return temp
    }()
    
    enum Direction {
        case left
        case rigth
    }
    
    override func setupViews() {
        super.setupViews()
        
        setupNavigation()
        
        self.view.addSubview(imageContainer)
        self.view.addSubview(leftButton)
        self.view.addSubview(rigthButton)
        
        NSLayoutConstraint.activate([
            
            imageContainer.safeTopAnchor.constraint(equalTo: view.safeTopAnchor),
            imageContainer.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            imageContainer.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            imageContainer.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            
            leftButton.safeCenterYAnchor.constraint(equalTo: view.safeCenterYAnchor),
            leftButton.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 15),
            leftButton.safeHeightAnchor.constraint(equalToConstant: 50),
            leftButton.safeWidthAnchor.constraint(equalToConstant: 20),
            
            rigthButton.safeCenterYAnchor.constraint(equalTo: view.safeCenterYAnchor),
            rigthButton.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -15),
            rigthButton.safeHeightAnchor.constraint(equalToConstant: 50),
            rigthButton.safeWidthAnchor.constraint(equalToConstant: 20),
            ])
        
        addGesturesToSwipeButtons()
    }
    
    func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedConstants.Send, style: .done, target: self, action: #selector(sendViaApp))
    }
}

extension HolyDayMessageViewController {
    
    @objc func sendViaApp() {
//        let urlWhats = "whatsapp://app"
//        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed) {
//            if let whatsappURL = URL(string: urlString) {
//
//                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
//
//                    if let imageData = templateImageArray[activeIndex].jpegData(compressionQuality: 1) {
//                        let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.jpeg")
//                        do {
//                            try imageData.write(to: tempFile, options: .atomic)
//                            self.documentInteractionController = UIDocumentInteractionController(url: tempFile)
//                            self.documentInteractionController.uti = "net.whatsapp.image"
//                            self.documentInteractionController.presentOpenInMenu(from: .zero, in: self.view, animated: true)
//
//                        } catch {
//                            debugPrint("Whatsapp open error:\(error)")
//                        }
//                    }
//                } else {
//                    debugPrint("Cannot open whatsapp")
//                }
//            }
//        }
        
        if let imageData = templateImageArray[activeIndex].jpegData(compressionQuality: 1) {
            let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.jpeg")
            do {
                try imageData.write(to: tempFile, options: .atomic)
                self.documentInteractionController = UIDocumentInteractionController(url: tempFile)
                self.documentInteractionController.uti = "net.whatsapp.image"
                self.documentInteractionController.presentOpenInMenu(from: .zero, in: self.view, animated: true)
                
            } catch {
                debugPrint("Whatsapp open error:\(error)")
            }
        }
    }
    
    private func startAnimationCommon(inputObject: UIView) {
        
        inputObject.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) // buton view kucultulur
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.50),  // yay sonme orani, arttikca yanip sonme artar
            initialSpringVelocity: CGFloat(6.0),    // yay hizi, arttikca hizlanir
            options: UIView.AnimationOptions.allowUserInteraction,
            animations: {
                
                inputObject.transform = CGAffineTransform.identity
        })
        inputObject.layoutIfNeeded()
    }
    
    private func swipeImages(direction: Direction) {
        switch direction {
        case .left:
            goToLeft()
        case .rigth:
            goToRigth()
        }
        
        changeImage()
    }
    
    private func goToRigth() {
        activeIndex += 1
        
        if activeIndex >= templateImageArray.endIndex {
            activeIndex = 0
        }
    }
    
    private func goToLeft() {
        activeIndex -= 1
        
        if activeIndex < templateImageArray.startIndex {
            activeIndex = templateImageArray.endIndex - 1
        }
    }
    
    private func changeImage() {
        DispatchQueue.main.async {
            UIView.transition(with: self.imageContainer, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                self.imageContainer.image = self.templateImageArray[self.activeIndex]
            }, completion: { (finish) in
                
            })
        }
    }
}


// MARK: - UIGestureRecognizerDelegate
extension HolyDayMessageViewController: UIGestureRecognizerDelegate {
    
    func addGesturesToSwipeButtons() {
        
        let leftGesture = UITapGestureRecognizer(target: self, action: #selector(leftTapped(_:)))
        leftGesture.delegate = self
        leftButton.addGestureRecognizer(leftGesture)
        
        let rigthGesture = UITapGestureRecognizer(target: self, action: #selector(rigthTapped(_:)))
        rigthGesture.delegate = self
        rigthButton.addGestureRecognizer(rigthGesture)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(_:)))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        
        let swipeRigth = UISwipeGestureRecognizer(target: self, action: #selector(rigthSwipe(_:)))
        swipeRigth.direction = .right
        swipeRigth.delegate = self
        
        self.imageContainer.addGestureRecognizer(swipeLeft)
        self.imageContainer.addGestureRecognizer(swipeRigth)
        
    }
    
    @objc private func leftTapped(_ sender: UITapGestureRecognizer) {
        startAnimationCommon(inputObject: leftButton)
        swipeImages(direction: .left)
    }
    
    @objc private func rigthTapped(_ sender: UITapGestureRecognizer) {
        startAnimationCommon(inputObject: rigthButton)
        swipeImages(direction: .rigth)
    }
    
    @objc private func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        swipeImages(direction: .rigth)
    }
    
    @objc private func rigthSwipe(_ sender: UISwipeGestureRecognizer) {
        swipeImages(direction: .left)
    }
    
}
