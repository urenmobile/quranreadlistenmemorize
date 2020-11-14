//
//  Endpoints.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 11/8/20.
//  Copyright © 2020 Remzi YILDIRIM. All rights reserved.
//

/*
 // Edition
 // http://api.alquran.cloud/v1/quran/{{edition}}
 
 // Take uthmani
 // http://api.alquran.cloud/v1/surah/1/quran-uthmani
 
 // After language selected
 // http://api.alquran.cloud/v1/edition?format=text&language=tr&type=translation
 
 // Audio per edition
 // https://cdn.alquran.cloud/media/audio/ayah/{{edition}}/{{ayah}}
 
 */

import Foundation

public enum Endpoints {
    
}

public protocol EndpointsConvertible {
    func asUrlRequest(with paths: [String]) -> URLRequest
    func asUrlRequestWith(query items: [URLQueryItem]) -> URLRequest
}

extension EndpointsConvertible {
    public func asUrlRequest(with paths: [String] = []) -> URLRequest {
        return asUrlRequest(with: paths)
    }
}

extension Endpoints {
    public enum Paths: String, EndpointsConvertible {
        case prayerCountries = "/ulkeler"
        case prayerCities = "/sehirler"
        case prayerCounties = "/ilceler"
        case prayerTimes = "/vakitler"
        case quranEditions = "/quran"
        case quranAvaliableAudio = "/edition/format/audio"
        case mediaAudio = "/media/audio/ayah"
        
        var host: String {
            let host: Environment.Host
            switch self {
            case .prayerCountries, .prayerCities, .prayerCounties, .prayerTimes:
                host = .prayer
            case .quranEditions, .quranAvaliableAudio:
                host = .quran
            case .mediaAudio:
                host = .cdn
            }
            return EnvironmentUtility.shared.environment.host(with: host)
        }
        
        public func asUrlRequest(with paths: [String] = []) -> URLRequest {
            var url = URL(string: host)!
            
             ([rawValue] + paths).forEach {
                url.appendPathComponent($0)
            }
            
            return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        }
        
        public func asUrlRequestWith(query items: [URLQueryItem]) -> URLRequest {
            let url = URL(string: host)!
            
            var components = URLComponents()
            components.scheme = url.scheme
            components.host = url.host
            components.path = rawValue
            components.queryItems = items
            
            guard let fullUrl = components.url else {
                return asUrlRequest()
            }
            
            return URLRequest(url: fullUrl, cachePolicy: .returnCacheDataElseLoad)
        }
        
        
    }
    
}
