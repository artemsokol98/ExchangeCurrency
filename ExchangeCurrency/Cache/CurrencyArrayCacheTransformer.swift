//
//  CurrencyArrayCacheTransformer.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 18.01.2023.
//

import Foundation

class CurrencyArrayTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let personsArray = value as? DataForCache else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: personsArray, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            guard let personsArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? DataForCache else { return nil }
            return personsArray
        } catch {
            return nil
        }
    }
}
