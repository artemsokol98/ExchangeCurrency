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
        newItem.date = urlStringWithDate
        newItem.arrayWithCurrencies?.data = valute
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func getCurrencyFromCache(urlStringWithDate: String) throws -> [String: Valute]? {
        let request = CurrencyArrayCache.fetchRequest() as NSFetchRequest<CurrencyArrayCache>
        request.predicate = NSPredicate(format: "date == %@", urlStringWithDate)
        
        do {
            guard let data = try? context.fetch(request) else {
                throw CoreDataErrors.CouldntFetchFromEntity
            
            }
            return data.first?.arrayWithCurrencies?.data
        } catch {
            
        }
        return nil
    }
}

enum CoreDataErrors: Error {
    case CouldntFetchFromEntity
}
