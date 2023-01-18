//
//  CurrencyArrayCache+CoreDataProperties.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 18.01.2023.
//
//

import Foundation
import CoreData


extension CurrencyArrayCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyArrayCache> {
        return NSFetchRequest<CurrencyArrayCache>(entityName: "CurrencyArrayCache")
    }

    @NSManaged public var date: String?
    @NSManaged public var arrayWithCurrencies: DataForCache?

}

extension CurrencyArrayCache : Identifiable {

}
