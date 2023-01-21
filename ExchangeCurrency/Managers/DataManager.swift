//
//  DataManager.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 18.01.2023.
//

import UIKit
import CoreData

class DataManager {
    static let shared = DataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func createNewItemForCurrency(urlStringWithDate: String, valute: [String: Valute]) {
        let newItem = CurrencyArrayCache(context: context)
        
        let valuteCache = DataForCache(data: valute)
        newItem.date = urlStringWithDate
        newItem.arrayWithCurrencies = valuteCache
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func getCurrencyFromCache(urlStringWithDate: String) throws -> [String: Valute]? {
        let request = CurrencyArrayCache.fetchRequest() as NSFetchRequest<CurrencyArrayCache>
        request.predicate = NSPredicate(format: "date == %@", urlStringWithDate)
        guard let data = try? context.fetch(request) else { throw CoreDataErrors.CouldntFetchFromEntity }
        return data.first?.arrayWithCurrencies?.data
    }
}

enum CoreDataErrors: Error {
    case CouldntFetchFromEntity
}
