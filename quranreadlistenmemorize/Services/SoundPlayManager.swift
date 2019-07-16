//
//  SoundPlayManager.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 3/3/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import AVFoundation

class SoundPlayManager {
    static let shared = SoundPlayManager()
    
    var player: AVAudioPlayer?
    
    func playSound(name: String) {
        //
        if name == Constants.DefaultSoundName {
            player?.stop()
            playDefaultNotificationSound()
            return
        }
        
        let resourceName = name.components(separatedBy: ".").first ?? ""
        let withExt = name.components(separatedBy: ".").last ?? ""
        
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: withExt) else { return }
        createPlaySession(url)
    }
    
    private func createPlaySession(_ url: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player = try AVAudioPlayer(contentsOf: url)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            debugPrint("Sound play Error:", error.localizedDescription)
        }
    }
    
    func playAyahSound(ayahNumber: Int) {
        APIManager.shared.downloadAndSaveLocalSound(ayahNumber: ayahNumber) { (result) in
            handleResult(result)
        }
        
        func handleResult(_ result: NetworkResult<URL>) {
            switch result {
            case .success(let url):
                createPlaySession(url)
            case .failure(let error):
                debugPrint("error oldu: \(error)")
            default:
                return
            }
        }
    }
    
    func stopSound() {
        player?.stop()
    }
    
    // http://iphonedevwiki.net/index.php/AudioServices
    let screenLockSoundID = 1100
    let keyPressedSoundID = 1105
    let notificationSoundID = 1007 //CalendarAlert: 1007, 1012
    func playDefaultNotificationSound() {
        AudioServicesPlayAlertSound(SystemSoundID(notificationSoundID))
    }
    
    func playKeyPressedSound(isSoundOn: Bool) {
        guard isSoundOn else {
            return
        }
//        AudioServicesPlayAlertSound(SystemSoundID(keyPressedSoundID))
        AudioServicesPlaySystemSound(SystemSoundID(keyPressedSoundID))
    }
    
    
    func playScreenLockSound(isSoundOn: Bool) {
        guard isSoundOn else {
            return
        }
//        AudioServicesPlayAlertSound(SystemSoundID(screenLockSoundID))
        AudioServicesPlaySystemSound(SystemSoundID(screenLockSoundID))
    }
    
}
