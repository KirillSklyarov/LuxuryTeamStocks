//
//  ContentTableView.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import UIKit

final class StocksTableView: UITableView {

    private var chosenCell: StocksTableViewCell?
    private var data: [StockModel]?

    private var isFavoriteChosen: Bool = true

    var onGetFilteredData: ((String) -> Void)?
    var tabSelected: ((Int) -> Void)?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setIsFavoriteChosen(_ isFavoriteChosen: Bool) {
        self.isFavoriteChosen = isFavoriteChosen
    }

//    func getData(_ data: [StockModel], animated: Bool = true) {
//        if self.data != data {
//            let deletedIndexes = getIndexesOfDeletedItems(data)
//            removeRowsOrUpdateCells(deletedIndexes)
//        }
//    }

    func filterData(by text: String) {
        onGetFilteredData?(text)
    }

    func updateUI(with data: [StockModel], isFavoriteChosen: Bool) {
        self.data = data
        setIsFavoriteChosen(isFavoriteChosen)
        reloadData()
    }
}

// MARK: - Setup UI
private extension StocksTableView {
    func setupUI() {
        showsVerticalScrollIndicator = false
        allowsSelection = false
        separatorStyle = .none
        registerCell(StocksTableViewCell.self)

        dataSource = self
        delegate = self

        //        estimatedRowHeight = 70/874
        //        rowHeight = UITableView.automaticDimension

    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension StocksTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(indexPath) as StocksTableViewCell
        let stockItem = data?[indexPath.row]

        guard let stockItem else { return cell }
        if !indexPath.row.isMultiple(of: 2) {
            cell.configureCell(with: stockItem, isGray: true)
        } else {
            cell.configureCell(with: stockItem)
        }


        //        cell.onTaskStateChanged = { [weak self] in
        //            self?.onChangeTDLState?(item)
        //        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        configureTableViewHeader(isFavoriteChosen)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
}

// MARK: - Supporting methods
private extension StocksTableView {
    func configureTableViewHeader(_ isFavoriteChosen: Bool) -> UIView {
        let stockButton = AppButton(style: .stocks, isSelected: !isFavoriteChosen)
        let favoriteButton = AppButton(style: .favourite, isSelected: isFavoriteChosen)

        let categoriesStackView = AppStackView([stockButton, favoriteButton, UIView()], axis: .horizontal, spacing: 20)

        categoriesStackView.backgroundColor = .systemBackground


        stockButton.onButtonTapped = { [weak self] tag in
            stockButton.applySelectedStyle(true)
            favoriteButton.applySelectedStyle(false)
            self?.tabSelected?(tag)
        }

        favoriteButton.onButtonTapped = { [weak self] tag in
            stockButton.applySelectedStyle(false)
            favoriteButton.applySelectedStyle(true)
            print(tag)
            self?.tabSelected?(tag)
        }

        return categoriesStackView
    }
}
