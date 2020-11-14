//
//  FileOperationProvider.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 11/8/20.
//  Copyright © 2020 Remzi YILDIRIM. All rights reserved.
//

import Foundation

public protocol FileOperationProvider: AnyObject {
    
    func localJsonFilePath(for url: URL) -> URL
}
