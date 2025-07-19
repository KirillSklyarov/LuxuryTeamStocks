//
//  ContentTableView.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import UIKit

enum Section {
    case main
}


final class StocksTableView: UITableView {

    private var diffableDataSource: UITableViewDiffableDataSource<Section, StockModel>!

    private var chosenCell: StocksTableViewCell?
    private var data: [StockModel]?

    private var isFavoriteChosen: Bool = true

    var onGetFilteredData: ((String) -> Void)?
    var tabSelected: ((Int) -> Void)?
    var onAddToFavButtonTapped: ((StockModel) -> Void)?

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

    func filterData(by text: String) {
        onGetFilteredData?(text)
    }

    func updateUI(with data: [StockModel], isFavoriteChosen: Bool, animate: Bool = true) {
        self.isFavoriteChosen = isFavoriteChosen
        print("isFavoriteChosen \(self.isFavoriteChosen)")

        var snapshot = NSDiffableDataSourceSnapshot<Section, StockModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)

        snapshot.reloadItems(data)

        diffableDataSource.apply(snapshot, animatingDifferences: animate)
    }
}

// MARK: - Setup UI
private extension StocksTableView {
    func setupUI() {
        showsVerticalScrollIndicator = false
        allowsSelection = false
        separatorStyle = .none
        registerCell(StocksTableViewCell.self)

        setupDataSource()

        delegate = self
    }

    func setupDataSource() {
        diffableDataSource = UITableViewDiffableDataSource<Section, StockModel>(tableView: self) { [weak self] tableView, indexPath, stock in
            guard let self else { return UITableViewCell() }
            let cell = tableView.dequeueCell(indexPath) as StocksTableViewCell


            let isGray = designEvenAndOddRows(for: indexPath)
            cell.configureCell(with: stock, isGray: isGray)

            cell.onAddToFavButtonTapped = {
                self.onAddToFavButtonTapped?(stock)
            }

            return cell
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension StocksTableView: UITableViewDelegate {
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
//            print(tag)
            self?.tabSelected?(tag)
        }

        return categoriesStackView
    }

    func designEvenAndOddRows(for indexPath: IndexPath) -> Bool {
        let isGray: Bool

        if isFavoriteChosen {
            isGray = indexPath.row.isMultiple(of: 2)
        } else {
            isGray = !indexPath.row.isMultiple(of: 2)
        }
        return isGray
    }
}

// MARK: - Setup Actions
//private extension StocksTableView {
//    func setupAction() {
//
//    }
//}


//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        data?.count ?? 0
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueCell(indexPath) as StocksTableViewCell
//        let stockItem = data?[indexPath.row]
//
//        guard let stockItem else { return cell }
//        if !indexPath.row.isMultiple(of: 2) {
//            cell.configureCell(with: stockItem, isGray: true)
//        } else {
//            cell.configureCell(with: stockItem)
//        }
//
//
//        cell.onAddToFavButtonTapped = { [weak self] in
//            self?.onAddToFavButtonTapped?(stockItem)
//        }
//
//        return cell
//    }
