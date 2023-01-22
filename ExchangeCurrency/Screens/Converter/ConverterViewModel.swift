//
//  ConverterViewModel.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import Foundation

protocol ConverterViewModelProtocol {
    var valute: Double { get set }
    var ruble: Double { get set }
    var dataAboutCurrency: ParsedCurrencyData { get set }
    func convertValuteToRuble()
    func convertRubleToValute()
}

class ConverterViewModel: ConverterViewModelProtocol {
    var valute: Double = 0.0
    var ruble: Double = 0.0
    var dataAboutCurrency: ParsedCurrencyData
    
    init(data: ParsedCurrencyData) {
        self.dataAboutCurrency = data
    }
    
    func convertValuteToRuble() {
        ruble = valute * dataAboutCurrency.value
    }
    
    func convertRubleToValute() {
        valute = ruble / dataAboutCurrency.value
    }
}
