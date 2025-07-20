//
//  MainViewModel.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import Foundation

protocol MainViewModelling: AnyObject {
    func viewLoaded()
    func eventHandler(_ event: MainViewModelEvent)
}

enum MainViewModelEvent {
    case showMoreButtonTapped
    case categoryChanged(Int)
    case addToFavoriteButtonTapped(StockModel)
    case filteringModeStarted(String)
}

final class MainViewModel: MainViewModelling {

    // MARK: - Properties
    private var data: [StockModel] = []
    private var favorites: [StockModel] = []
    private var displayData: [StockModel] = []

    private var isFavoritesChosen = false
    private var isFiltering = false
    private var filterText: String = ""

    private var userDefaults = UDManager.shared

    weak var view: MainViewController?

    // MARK: - Init
    init() {
        getFavoritesFromUD()
    }
}

// MARK: - MainViewModelling
extension MainViewModel {
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
    }

    func eventHandler(_ event: MainViewModelEvent) {
        switch event {
        case .showMoreButtonTapped: showAllFilteredElements()
        case .categoryChanged(let tag): tabSelected(tag)
        case .addToFavoriteButtonTapped(let stock): addOrRemoveFromFavorites(stock)
        case .filteringModeStarted(let filterText): filterStocks(by: filterText)
        }
    }
}

// MARK: - Supporting methods
private extension MainViewModel {
    func mappingMockData() {
        let favSymbols = Set(favorites.map { $0.symbol })
        self.data = mockData.map { stock in
            var copy = stock
            copy.isFavorite = favSymbols.contains(stock.symbol)
            return copy
        }
    }

    func showAllFilteredElements(animate: Bool = true) {
        displayData = getCorrectData()
        view?.configure(with: displayData, isFavoritesChosen, animate: animate)
    }

    func tabSelected(_ index: Int) {
        if index == 0 {
            isFavoritesChosen = false
        } else if index == 1 {
            isFavoritesChosen = true
        }
        updateView()
    }

    func addOrRemoveFromFavorites(_ stock: StockModel) {
        setStockAsFavorite(stock)
        updateView(animate: false)
    }

    func filterStocks(by text: String) {
        if text.isEmpty {
            isFiltering = false
            filterText = ""
        } else {
            isFiltering = true
            filterText = text
        }
        updateView()
    }

    func loadData() {
        view?.loading()
        mappingMockData()
        checkDataAndUpdateView()
    }

    func getFavoritesFromUD() {
        self.favorites = userDefaults.loadFavouritesFromUD()
    }

    func getCorrectData() -> [StockModel] {
        updateFavorites()
        let base = isFavoritesChosen ? favorites : data
        //        print(base, filterText)

        if filterText.isEmpty {
            return base
        } else {
            return base.filter {
                $0.symbol.lowercased().contains(filterText.lowercased()) ||
                $0.name.lowercased().contains(filterText.lowercased())
            }
        }
    }

    func updateFavorites() {
        favorites = data.filter { $0.isFavorite }
    }

    func checkDataAndUpdateView() {
        isDataValid() ? updateView() : getError()
    }

    func isDataValid() -> Bool {
        return !data.isEmpty
    }

    func updateView(animate: Bool = true) {
        updateFavorites()
        displayData = getCorrectData()
        if isFiltering {
            showFirstFourElements()
        } else {
            view?.configure(with: displayData, isFavoritesChosen, animate: animate)
        }
    }

    func showFirstFourElements(animate: Bool = true) {
        if displayData.count < 4 {
            view?.configure(with: displayData, isFavoritesChosen, animate: animate)
        } else {
            print("Here")
            let first4 = Array(displayData.prefix(4))
            print(first4.count)
            view?.configure(with: first4, isFavoritesChosen, animate: animate)
        }
    }
    
    func getError() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError()
        }
    }

    func setStockAsFavorite(_ stock: StockModel) {
        if let index = data.firstIndex(of: stock) {
            data[index].isFavorite.toggle()
        }
    }
}
