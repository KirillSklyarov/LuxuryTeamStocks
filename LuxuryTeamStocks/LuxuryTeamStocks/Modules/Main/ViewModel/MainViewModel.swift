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
}

final class MainViewModel: MainViewModelling {

    private var data: [StockModel] = []
    private var favourites: [StockModel] = []
    private var displayData: [StockModel] = []

    private var isFavoritesChosen = false

    weak var view: MainViewController?

    func viewLoaded() {
        print(#function)
        view?.setupInitialState()
        loadData()
    }

    func tabSelected(_ index: Int) {
        if index == 0 {
            displayData = data
            isFavoritesChosen = false
        } else if index == 1 {
            displayData = [data.first!]
            isFavoritesChosen = true
        }
        view?.configure(with: displayData, isFavoritesChosen)
    }

    func loadData() {
        view?.loading()
        self.data = mockData
//        print(data)
        checkDataAndUpdateView()
    }

    func checkDataAndUpdateView() {
        isDataValid() ? updateView() : getError()
    }

    func isDataValid() -> Bool {
        return !data.isEmpty
    }

    func updateView() {
        print(#function)
        view?.configure(with: data, isFavoritesChosen)
    }

    func getError() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError()
        }
    }









}
