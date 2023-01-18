//
//  MainViewModel.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import Foundation

protocol MainViewModelProtocol {
    var parsedData: [ParsedCurrencyData] { get set }
    func fetchData(url:String, completion: @escaping (Result<Void,Error>) -> Void)
}

class MainViewModel: MainViewModelProtocol {
    
    var parsedData = [ParsedCurrencyData]()
    
    // let apiStringForDate = "www.cbr-xml-daily.ru/archive/2023/01/17/daily_json.js"
    
    func fetchData(url:String, completion: @escaping (Result<Void,Error>) -> Void) {
        
        if url.contains("www.cbr-xml-daily.ru/archive/") {
            do {
                guard let data = try? DataManager.shared.getCurrencyFromCache(urlStringWithDate: url) else { throw CoreDataErrors.CouldntFetchFromEntity }
                print(data)
                self.parsedData = self.parseOnlyValuteDate(data: data)
                completion(.success(()))
            } catch {
                NetworkManager.shared.fetchInformation(urlString: url, expectingType: Currency.self) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            guard let data = data as? Currency else { print("Casting failed"); return }
                            self.parsedData = self.parseFetchedData(data: data)
                            DataManager.shared.createNewItemForCurrency(urlStringWithDate: url, valute: data.valute)
                            completion(.success(()))
                        case .failure(let error):
                            //print(error)
                            completion(.failure(error))
                        }
                    }
                }
            }
        } else {
            NetworkManager.shared.fetchInformation(urlString: url, expectingType: Currency.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        guard let data = data as? Currency else { print("Casting failed"); return }
                        self.parsedData = self.parseFetchedData(data: data)
                        completion(.success(()))
                    case .failure(let error):
                        //print(error)
                        completion(.failure(error))
                    }
                }
            }
            
        }
        
        
        
        
    }
    
    func parseFetchedData(data: Currency) -> [ParsedCurrencyData] {
        var parsedData = [ParsedCurrencyData]()
        for item in data.valute {
            let data = ParsedCurrencyData(
                charCode: item.value.charCode,
                value: item.value.value,
                name: item.value.name
            )
            parsedData.append(data)
        }
        return parsedData
    }
    
    func parseOnlyValuteDate(data: [String: Valute]) -> [ParsedCurrencyData] {
        var parsedData = [ParsedCurrencyData]()
        for item in data {
            let data = ParsedCurrencyData(
                charCode: item.value.charCode,
                value: item.value.value,
                name: item.value.name
            )
            parsedData.append(data)
        }
        return parsedData
    }
}
