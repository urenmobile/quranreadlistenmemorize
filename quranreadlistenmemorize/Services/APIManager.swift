//
//  APIManager.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

// info: https://stackoverflow.com/questions/38060567/show-loading-percentage-of-image-download-from-url-with-swift

import Foundation

enum NetworkResult<T> {
    case progress(_ written: String, _ expected: String, _ progress: Float)
    case success(T)
    case failure(BackEndAPIError)
    
    enum BackEndAPIError: Error {
        // The Server returned no data
        case missingDataError
        // The Server returned wrong data
        case parseDataError
        // Can't connect to the server (maybe offline?)
        case connectionError(_ error: Error)
        // The server responded with a non 200 status code
        case serverError(_ error: Error)
    }
}

class APIManager: NSObject {
    
    static let shared = APIManager()

    var session : URLSession {
        get {
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad
            config.urlCache = URLCache.shared
            return URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        }
    }
    weak var dataTask: URLSessionDataTask?
    weak var downloadTask: URLSessionDownloadTask?
    
    var completion: ((NetworkResult<Bool>) -> Void)?
    
    private let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        return formatter
    }()
    
    // information function
    func downloadAndSaveLocal(identifier: String) {
        let urlString = Constants.ApiEndpoint.QuranEditionUrl + identifier
        
        guard let url = URL(string: urlString) else { return }
        downloadTask?.cancel()
        
        // Don't specify a completion handler here or the delegate won't be called
        downloadTask = session.downloadTask(with: url)
        downloadTask?.resume()
    }
    
    // Ayah Sound
    func downloadAndSaveLocalSound(ayahNumber: Int, completion: @escaping (NetworkResult<URL>) -> Void) {
        
        if FileOperationManager.shared.checkFileExists(ayahNumber: ayahNumber) {
            completion(.success(FileOperationManager.shared.localMp3FilePath(for: ayahNumber)))
            return
        }
        
        let urlString = Constants.ApiEndpoint.QuranMediaAudio + "\(PersistentManager.shared.appConfiguration.selectedAudioEditionId)/" + "\(ayahNumber)"
        guard let downloadUrl = URL(string: urlString) else { return }
        
        let task = session.downloadTask(with: downloadUrl) { (url, response, error) in
            if let error = error {
                debugPrint("Error oldu: \(error)")
                completion(.failure(.serverError(error)))
            }
            
            guard let url = url else {
                completion(.failure(.missingDataError))
                return
            }
            
            let destinationURL = FileOperationManager.shared.localMp3FilePath(for: ayahNumber)
            let fileManager = FileManager.default
            try? fileManager.removeItem(at: destinationURL)
            do {
                try fileManager.moveItem(at: url, to: destinationURL)
                completion(.success(destinationURL))
            } catch let error {
                debugPrint("Could not copy file to disk: \(error)")
            }
        }
        task.resume()
    }
    
    func getDataWithNoCache<T: Decodable>(_ parseType: T.Type, urlString: String, completion: @escaping (NetworkResult<[T]>) -> Void) {
        guard let request = makeRequest(urlString) else { return }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                debugPrint("Error oldu: \(error)")
                completion(NetworkResult.failure(NetworkResult.BackEndAPIError.serverError(error)))
            }
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    debugPrint("Server Response Error)")
                    return }
            
            // Parse data
            do {
                let parsedObject = try JSONDecoder().decode([T].self, from: data)
                completion(.success(parsedObject))
                
            } catch let parsingError {
                debugPrint("Error: when parsing: \(parsingError)")
                completion(.failure(.parseDataError))
            }
        }
        task.resume()
    }
    
    //
    func getDataWithCache<T: Decodable>(_ parseType: T.Type, urlString: String, completion: @escaping (NetworkResult<[T]>) -> Void) {
        guard let request = makeRequest(urlString) else { return }
        
        if let data = getFromCache(request: request) {
            // Parse data
            do {
                let parsedObject = try JSONDecoder().decode([T].self, from: data)
                completion(.success(parsedObject))
                
            } catch let parsingError {
                debugPrint("Error: when parsing: \(parsingError)")
                completion(.failure(.parseDataError))
            }
        } else {
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    debugPrint("Error session dataTask: \(error)")
                    completion(NetworkResult.failure(NetworkResult.BackEndAPIError.serverError(error)))
                }
                
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        debugPrint("Server Response Error")
                        return }
                
                // Parse data
                do {
                    let parsedObject = try JSONDecoder().decode([T].self, from: data)
                    completion(.success(parsedObject))
                    
                    // parse success then cache data
                    let cachedData = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cachedData, for: request)
                    
                } catch let parsingError {
                    debugPrint("Error: when parsing: \(parsingError)")
                    completion(.failure(.parseDataError))
                }
            }
            task.resume()
        }
    }
    
    private func makeRequest(_ urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    }
    
    func getFromCache(request: URLRequest) -> Data? {
        if let response = URLCache.shared.cachedResponse(for: request) {
            return response.data
        }
        return nil
    }
    
}

extension APIManager: URLSessionDelegate, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            debugPrint("Task completed with Error: \(task), error: \(error)")
            completion?(.failure(.serverError(error)))
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let written = byteFormatter.string(fromByteCount: totalBytesWritten)
        let expected = byteFormatter.string(fromByteCount: totalBytesExpectedToWrite)
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        completion?(NetworkResult.progress(written, expected, progress))
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        let destinationURL = FileOperationManager.shared.localJsonFilePath(for: sourceURL)
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
        } catch let error {
            debugPrint("Could not copy file to disk: \(error.localizedDescription)")
        }
        completion?(.success(true))
    }
    
}
