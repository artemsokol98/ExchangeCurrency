//
//  DataForCacheModel.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 23.01.2023.
//

import Foundation

// MARK: - Format data for cache
public class DataForCache: NSObject {
    var data: [String: Valute]
    
    init(data: [String: Valute]) {
        self.data = data
    }
}
