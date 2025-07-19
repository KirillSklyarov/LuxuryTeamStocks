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
        view?.setupInitialState()
        loadData()
        print(#function)
    }

    func loadData() {
        view?.loading()
        self.data = mockData
    }





}
