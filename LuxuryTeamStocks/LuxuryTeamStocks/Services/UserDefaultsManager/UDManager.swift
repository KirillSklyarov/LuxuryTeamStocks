//
//  UDManager.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import Foundation

protocol UDManagerProtocol {
    func addToFavorites(_ stock: StockModel)
    func removeFromFavorites(_ stock: StockModel)
    func loadFavouritesFromUD() -> [StockModel]
}

final class UDManager: UDManagerProtocol {

    static let shared = UDManager()
    private init() {}

    private let defaults = UserDefaults.standard

    // MARK: - CRUD
    func addToFavorites(_ stock: StockModel) {
        var favourites = loadFavouritesFromUD()

        if !favourites.contains(where: { $0.symbol == stock.symbol }) {
            favourites.append(stock)
            print("✅ Added to favourites")
        }

        saveFavouritesToUD(favourites)
    }

    func removeFromFavorites(_ stock: StockModel) {
        var favourites = loadFavouritesFromUD()

        favourites.removeAll(where: { $0.symbol == stock.symbol })
        print("✅ Removed from favourites")

        saveFavouritesToUD(favourites)
    }

    func loadFavouritesFromUD() -> [StockModel] {
        var favourites: [StockModel] = []
        if let savedData = defaults.data(forKey: AppConstants.UserDefaultsKeys.favourites),
           let decoded = try? JSONDecoder().decode([StockModel].self, from: savedData) {
            favourites = decoded
        }
        return favourites
    }
}

// MARK: - Supporting methods
private extension UDManager {
    func saveFavouritesToUD(_ data: [StockModel]) {
        if let newData = try? JSONEncoder().encode(data) {
            defaults.set(newData, forKey: AppConstants.UserDefaultsKeys.favourites)
            print("✅ Saved to UD")
        }
    }
}
