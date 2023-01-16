//
//  MainViewModel.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import Foundation

protocol MainViewModelProtocol {
    var parsedData: [ParsedCurrencyData] { get set }
    func fetchData(completion: @escaping (Result<Void,Error>) -> Void)
}

class MainViewModel: MainViewModelProtocol {
    
    var parsedData = [ParsedCurrencyData]()
    
    func fetchData(completion: @escaping (Result<Void,Error>) -> Void) {
        NetworkManager.shared.fetchInformation(urlString: "https://www.cbr-xml-daily.ru/daily_json.js", expectingType: Currency.self) { result in
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
}
