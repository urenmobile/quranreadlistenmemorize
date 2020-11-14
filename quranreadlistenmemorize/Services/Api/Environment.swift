//
//  Environment.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 11/8/20.
//  Copyright © 2020 Remzi YILDIRIM. All rights reserved.
//

import Foundation

public enum Environment {
    case development
    case test
    case preprod
    case prod
    case release
    
    public var name: String {
        switch self {
        case .development:
            return "DEV"
        case .test:
            return "TEST"
        case .preprod:
            return "PRE PROD"
        case .prod:
            return "PROD"
        case .release:
            return ""
        }
    }
    
    // TODO: unfortunately host names taken differen api
    public func host(with host: Environment.Host) -> String {
        // Should be separated by the environment
        return host.urlString
    }
}

extension Environment {
    // TODO: Temporary solution for different host name
    public enum Host {
        case prayer
        case quran
        case cdn
        
        public var urlString: String {
            switch self {
            case .prayer:
                return "https://ezanvakti.herokuapp.com"
            case .quran:
                return "http://api.alquran.cloud/v1"
            case .cdn:
                return "https://cdn.alquran.cloud"
            }
        }
    }
}
