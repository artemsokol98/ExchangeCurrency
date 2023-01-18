//
//  CurrencyModel.swift
//  ExchangeCurrency
//
//  Created by Артем Соколовский on 16.01.2023.
//

import Foundation

// MARK: - Currency
struct Currency: Decodable {
    let date, previousDate, previousURL, timestamp: String
    let valute: [String: Valute]

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case previousDate = "PreviousDate"
        case previousURL = "PreviousURL"
        case timestamp = "Timestamp"
        case valute = "Valute"
    }
}

// MARK: - Valute
struct Valute: Decodable {
    let id, numCode, charCode: String
    let nominal: Int
    let name: String
    let value, previous: Double

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case numCode = "NumCode"
        case charCode = "CharCode"
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
        case previous = "Previous"
    }
}

public class DataForCache: NSObject {
    var data: [String: Valute]?
}
