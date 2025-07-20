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
    func filterStocks(by text: String) 
}

final class MainViewModel: MainViewModelling {

    private var data: [StockModel] = []
    private var favorites: [StockModel] = []
    private var displayData: [StockModel] = []

    private var isFavoritesChosen = false
    private var isFiltering = false
    private var filterText: String = ""

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

    func filterStocks(by text: String) {
        let base = isFavoritesChosen ? favorites : data
        print(#function)

        if text.isEmpty {
            isFiltering = false
            filterText = ""
            displayData = base
        } else {
            isFiltering = true
            filterText = text
            displayData = base.filter {
                $0.symbol.lowercased().contains(text.lowercased()) ||
                $0.name.lowercased().contains(text.lowercased())
            }
        }
        view?.configure(with: displayData, isFavoritesChosen, animate: true)
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
//        print(correctData)

        if index == 0 {
            isFavoritesChosen = false
            let correctData = getCorrectData()
            displayData = correctData
        } else if index == 1 {
            isFavoritesChosen = true
            let correctData = getCorrectData()
            displayData = correctData.filter { $0.isFavorite }
        }
        view?.configure(with: displayData, isFavoritesChosen)
    }

    private func getCorrectData() -> [StockModel] {
        let base = isFavoritesChosen ? favorites : data
        print(base, filterText)
        var newData: [StockModel] = []
        if filterText.isEmpty {
            newData = base
        } else {
            newData = base.filter {
                $0.symbol.lowercased().contains(filterText.lowercased()) ||
                $0.name.lowercased().contains(filterText.lowercased())
            }
        }
        return newData
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
