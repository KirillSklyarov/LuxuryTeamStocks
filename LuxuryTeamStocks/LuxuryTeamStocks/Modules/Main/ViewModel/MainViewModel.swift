//
//  MainViewModel.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import Foundation

protocol MainViewModelling: AnyObject {
    func viewLoaded()
    func tabSelected(_ index: Int)
    func addOrRemoveFromFavorites(_ stock: StockModel)
}

final class MainViewModel: MainViewModelling {

    private var data: [StockModel] = []
    private var favorites: [StockModel] = []
    private var displayData: [StockModel] = []

    private var isFavoritesChosen = false

    private var userDefaults = UDManager.shared

    weak var view: MainViewController?

    init() {
        getFavoritesFromUD()
    }

    func viewLoaded() {
//        print(#function)
        view?.setupInitialState()
        loadData()
    }

    private func mappingMockData() {
        let favSymbols = Set(favorites.map { $0.symbol })
        self.data = mockData.map { stock in
            var copy = stock
            copy.isFavorite = favSymbols.contains(stock.symbol)
            return copy
        }
    }

    func loadData() {
        view?.loading()
        mappingMockData()
        checkDataAndUpdateView()
    }

    private func getFavoritesFromUD() {
        self.favorites = userDefaults.loadFavouritesFromUD()
        //        print(favourites)
    }

    func tabSelected(_ index: Int) {
        if index == 0 {
            displayData = data
            isFavoritesChosen = false
        } else if index == 1 {
            displayData = data.filter { $0.isFavorite }
            isFavoritesChosen = true
        }
        view?.configure(with: displayData, isFavoritesChosen)
    }

    func checkDataAndUpdateView() {
        isDataValid() ? updateView() : getError()
    }

    func isDataValid() -> Bool {
        return !data.isEmpty
    }

    private func updateView(animate: Bool = true) {
        let fav = data.filter { $0.isFavorite }
        displayData = isFavoritesChosen ? fav : data
        view?.configure(with: displayData, isFavoritesChosen, animate: animate)
    }

    func getError() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError()
        }
    }

    func addOrRemoveFromFavorites(_ stock: StockModel) {
        modifyData(with: stock)
        updateView(animate: false)
    }

    private func modifyData(with stock: StockModel) {
        if let index = data.firstIndex(of: stock) {
            data[index].isFavorite.toggle()
        }
    }
}
