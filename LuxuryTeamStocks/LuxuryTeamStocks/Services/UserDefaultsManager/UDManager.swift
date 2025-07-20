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
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let queue = DispatchQueue(label: "ru.luxuryTeam.UDManagerQueue", qos: .background)

    // MARK: - CRUD
    func addToFavorites(_ stock: StockModel) {
        queue.async { [weak self] in
            guard let self else { return }
            var favourites = loadFavouritesFromUD()
            if !favourites.contains(where: { $0.symbol == stock.symbol }) {
                favourites.append(stock)
                print("✅ Added to favourites: \(stock.symbol)")
            }

            saveFavouritesToUD(favourites)
        }
    }

    func removeFromFavorites(_ stock: StockModel) {
        queue.async { [weak self] in
            guard let self else { return }
            var favourites = loadFavouritesFromUD()
            favourites.removeAll(where: { $0.symbol == stock.symbol })
            print("✅ Removed from favourites \(stock.symbol)")

            saveFavouritesToUD(favourites)
        }
    }

    func loadFavouritesFromUD() -> [StockModel] {
        if let savedData = defaults.data(forKey: AppConstants.UserDefaultsKeys.favourites),
           let decoded = try? decoder.decode([StockModel].self, from: savedData) {
            print("✅ Loaded favourites from UD: \(decoded.count) items")
            return decoded
        } else {
            print("🔴 No data found in UD")
            return []
        }
    }
}

// MARK: - Supporting methods
private extension UDManager {
    func saveFavouritesToUD(_ data: [StockModel]) {
        queue.async { [weak self] in
            guard let self else { return }
            if let newData = try? encoder.encode(data) {
                defaults.set(newData, forKey: AppConstants.UserDefaultsKeys.favourites)
                print("✅ Data saved to UD")
            }
        }
    }
}

//    func saveAllChangesToUD() {
//        let favorites = mockData.filter { $0.isFavorite }
//        print(favorites)
//        saveFavouritesToUD(favorites)
//    }
