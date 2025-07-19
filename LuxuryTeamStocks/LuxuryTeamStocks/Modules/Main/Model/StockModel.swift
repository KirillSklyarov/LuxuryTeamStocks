//
//  StockModel.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//


import Foundation

struct StockModel: Codable, Equatable {
    let symbol: String
    let name: String
    let price: Double
    let change: Double
    let changePercent: Double
    let logo: String
    var isFavorite: Bool = false
}

let mockData: [StockModel] = [
    StockModel(symbol: "AAPL", name: "Apple Inc.", price: 131.93, change: 0.12, changePercent: 0.13, logo: "https://mustdev.ru/images/AAPL"),
    StockModel(symbol: "GOOGL", name: "Alphabet Class A", price: 1825.00, change: 0.12, changePercent: 0.13, logo: "https://mustdev.ru/images/GOOGL"),
    StockModel(symbol: "AMZN", name: "Amazon.com", price: 3204.00, change: -0.12, changePercent: -0.13, logo: "https://mustdev.ru/images/AMZN"),
    StockModel(symbol: "BAC", name: "Bank of America Corp", price: 3204.00, change: 0.12, changePercent: 0.13, logo: "https://mustdev.ru/images/BAC"),
    StockModel(symbol: "MSFT", name: "Microsoft Corporation", price: 3204.00, change: 0.12, changePercent: 0.13, logo: "https://mustdev.ru/images/MSFT"),
    StockModel(symbol: "TSLA", name: "Tesla Motors", price: 3204.00, change: 0.12, changePercent: 0.13, logo: "https://mustdev.ru/images/TSLA"),
    StockModel(symbol: "MA", name: "Mastercard", price: 3204.00, change: 0.12, changePercent: 0.13, logo: "https://mustdev.ru/images/MA"),
    StockModel(symbol: "YNDX", name: "Yandex, LLC", price: 131.6, change: 0.9, changePercent: 0.3, logo: "https://mustdev.ru/images/YNDX"),
    StockModel(symbol: "BAC", name: "Bank of America Corp", price: 3204.00, change: 0.12, changePercent: 0.13, logo: "https://mustdev.ru/images/BAC"),
    StockModel(symbol: "MSFT", name: "Microsoft Corporation", price: 3204.00, change: 0.12, changePercent: 0.13, logo: "https://mustdev.ru/images/MSFT"),
    StockModel(symbol: "TSLA", name: "Tesla Motors", price: 3204.00, change: 0.12, changePercent: 0.13, logo: "https://mustdev.ru/images/TSLA"),
    StockModel(symbol: "MA", name: "Mastercard", price: 3204.00, change: 0.12, changePercent: 0.13, logo: "https://mustdev.ru/images/MA"),
    StockModel(symbol: "YNDX", name: "Yandex, LLC", price: 131.6, change: 0.9, changePercent: 0.3, logo: "https://mustdev.ru/images/YNDX")
]
