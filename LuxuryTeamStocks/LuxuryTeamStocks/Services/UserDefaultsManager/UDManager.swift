//
//  UDManager.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import Foundation

final class UDManager {

    static let shared = UDManager()
    private let defaults = UserDefaults.standard

    private init() {}

    func addToFavorites(_ stock: StockModel) {
        var favourites = loadFavouritesFromUD()

        if !favourites.contains(where: { $0.symbol == stock.symbol }) {
            favourites.append(stock)
        }

        saveFavouritesToUD(favourites)
    }

    func removeFromFavorites(_ stock: StockModel) {
        var favourites = loadFavouritesFromUD()

        favourites.removeAll(where: { $0.symbol == stock.symbol })

        saveFavouritesToUD(favourites)
    }
}

// MARK: - Supporting methods
private extension UDManager {
    func loadFavouritesFromUD() -> [StockModel] {
        var favourites: [StockModel] = []
        if let savedData = defaults.data(forKey: AppConstants.UserDefaultsKeys.favourites),
           let decoded = try? JSONDecoder().decode([StockModel].self, from: savedData) {
            favourites = decoded
        }
        return favourites
    }

    func saveFavouritesToUD(_ data: [StockModel]) {
        if let newData = try? JSONEncoder().encode(data) {
            defaults.set(newData, forKey: AppConstants.UserDefaultsKeys.favourites)
        }
    }
}
