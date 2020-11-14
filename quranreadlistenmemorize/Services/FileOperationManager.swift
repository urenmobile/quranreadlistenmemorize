//
//  FileOperationManager.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/7/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class FileOperationManager {
    static let shared = FileOperationManager()
    
    // Get local file path: download task stores tune here.
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func localJsonFilePath(for url: URL) -> URL {
        let fileName = url.lastPathComponent + ".\(Constants.Bundle.FileType.Json)"
        return documentsPath.appendingPathComponent(fileName)
    }
    
    func localMp3FilePath(for ayahNumber: Int) -> URL {
        let fileName = PersistentManager.shared.appConfiguration.selectedAudioEditionId + "_\(ayahNumber).\(Constants.Bundle.FileType.Mp3)"
        return documentsPath.appendingPathComponent(fileName)
    }
    
    func checkFileExists(identifier: String) -> Bool {
        let filePath = getFilePath(identifier)
        return FileManager.default.fileExists(atPath: filePath.path)
    }
    
    func getFilePath(_ identifier: String) -> URL {
        let fileName = identifier + ".\(Constants.Bundle.FileType.Json)"
        return documentsPath.appendingPathComponent(fileName)
    }
    
    func checkFileExists(ayahNumber: Int) -> Bool {
        let filePath = localMp3FilePath(for: ayahNumber)
        return FileManager.default.fileExists(atPath: filePath.path)
    }
    
    // Editions Local file
    func getQuranEditions() -> [Edition] {
        var editions = [Edition]()
        let resource = Constants.Bundle.Path.QuranEditions
        let fileType = Constants.Bundle.FileType.Json
        guard let data = getDataFrom(resourceName: resource, fileType: fileType) else {
            return editions
        }
        
        do {
            let responseEdition = try JSONDecoder().decode(ResponseEdition.self, from: data)
            editions = responseEdition.data
        } catch {
            return editions
        }
        return editions
    }
    
    // Qurans Local file
    func getQuranFromResource(quranType: QuranType) -> Quran? {
        let resource = quranType.resourceName()
        let fileType = Constants.Bundle.FileType.Json
        guard let data = getDataFrom(resourceName: resource, fileType: fileType) else {
            return nil
        }
        
        do {
            let responseEdition = try JSONDecoder().decode(ResponseQuran.self, from: data)
            return responseEdition.data
        } catch {
            return nil
        }
    }
    
    private func getDataFrom(resourceName: String, fileType: String) -> Data? {
        let frameworkBundle = Bundle(for: FileOperationManager.self)
        guard let jsonPath = frameworkBundle.path(forResource: resourceName, ofType: fileType), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            debugPrint("Bundle cann't found: \(resourceName).\(fileType)")
            return nil
        }
        return data
    }
    
    // Downloaded
    func getQuranDownloaded(_ identifier: String) -> Quran? {
        guard checkFileExists(identifier: identifier) else {
            return nil
        }
        
        let filePath = getFilePath(identifier)
        
        if let data = try? Data(contentsOf: filePath, options: .mappedIfSafe) {
            do {
                let responseEdition = try JSONDecoder().decode(ResponseQuran.self, from: data)
                return responseEdition.data
            } catch {
                return nil
            }
        }
        return nil
    }
    
    // denendi
    private func saveToJsonFile(surah: Surah, fileName: String) {
        
        // Get Documents directory in app bundle
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("No document directory found in application bundle.")
        }
        
        // Get URL for dest file (in Documents directory)
        let createFolderURL = documentsDirectory.appendingPathComponent(Constants.Bundle.Path.QuranEditionFolder)
        
        try? FileManager.default.createDirectory(atPath: createFolderURL.path, withIntermediateDirectories: true)
        //        try? text.write(to: writableFileURL, atomically: false, encoding: String.Encoding.utf8)
        
        // Transform array into data and save it into file
        let writableFileURL = createFolderURL.appendingPathComponent(fileName)
        do {
            let data = try JSONSerialization.data(withJSONObject: surah, options: JSONSerialization.WritingOptions.prettyPrinted)
            try data.write(to: writableFileURL)
        } catch {
            debugPrint("JSON file writing error: \(error)")
        }
    }
    
    // denendi
    private func saveToJsonFileShort(quranShort: QuranShort, fileName: String) {
        
        // Get Documents directory in app bundle
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("No document directory found in application bundle.")
        }
        
        // Get URL for dest file (in Documents directory)
        let createFolderURL = documentsDirectory.appendingPathComponent(Constants.Bundle.Path.QuranEditionFolder)
        
        try? FileManager.default.createDirectory(atPath: createFolderURL.path, withIntermediateDirectories: true)
        
        // Transform array into data and save it into file
        let writableFileURL = createFolderURL.appendingPathComponent(fileName)
        do {
            let data = try JSONEncoder().encode(quranShort)
            try data.write(to: writableFileURL)
        } catch {
            debugPrint("JSON file writing error: \(error)")
        }
    }
    
    func saveFile(from sourceUrl: URL, to destinationUrl: URL) -> Bool? {
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationUrl)
        do {
            try fileManager.moveItem(at: sourceUrl, to: destinationUrl)
            return true
        } catch let error {
            debugPrint("Could not copy file to disk: \(error)")
        }
        return nil
    }
    
    func copyFile(from sourceUrl: URL, to destinationUrl: URL) {
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationUrl)
        do {
            try fileManager.copyItem(at: sourceUrl, to: destinationUrl)
        } catch let error {
            debugPrint("Could not copy file to disk: \(error.localizedDescription)")
        }
    }
    
    
    // Dhikrs Local file
    func getDhikrsFromResource() -> [Dhikr]? {
        let resource = Constants.Bundle.Path.Dhikrs
        let fileType = Constants.Bundle.FileType.Json
        guard let data = getDataFrom(resourceName: resource, fileType: fileType) else {
            return nil
        }
        
        do {
            let dhikrs = try JSONDecoder().decode([Dhikr].self, from: data)
            return dhikrs
        } catch {
            return nil
        }
    }
}
