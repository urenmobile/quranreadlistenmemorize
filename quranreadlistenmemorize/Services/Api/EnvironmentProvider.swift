//
//  EnvironmentProvider.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 11/8/20.
//  Copyright © 2020 Remzi YILDIRIM. All rights reserved.
//

import Foundation

public protocol EnvironmentProvider {
    var environment: Environment { get }
    func canChangeEnvironment() -> Bool
    func changeEnvironment(to environment: Environment)
}
