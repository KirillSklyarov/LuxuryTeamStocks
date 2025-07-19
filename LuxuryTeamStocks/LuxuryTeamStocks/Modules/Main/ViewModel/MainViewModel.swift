//
//  MainViewModel.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import Foundation

protocol MainViewModelling: AnyObject {
    func viewLoaded()
}

final class MainViewModel: MainViewModelling {

    private var data: [StockModel] = []

    weak var view: MainViewController?

    func viewLoaded() {
        print(#function)
        view?.setupInitialState()
        loadData()
    }

    func loadData() {
        view?.loading()
        self.data = mockData
        print(data)
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
        view?.configure(with: data)
    }

    func getError() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError()
        }
    }









}
