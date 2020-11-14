//
//  EnvironmentUtility.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 11/8/20.
//  Copyright © 2020 Remzi YILDIRIM. All rights reserved.
//

import Foundation

public class EnvironmentUtility: EnvironmentProvider {
    
    public static let shared = EnvironmentUtility()
    /// Current environment
    public private(set) var environment: Environment = .development
    
    /// Return current environment can change able or not
    public func canChangeEnvironment() -> Bool {
        return environment != .release && environment != .prod
    }
    
    public func changeEnvironment(to environment: Environment) {
        guard canChangeEnvironment() else { return }
        self.environment = environment
    }
}
