//
//  StocksTableViewCell.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import UIKit
import SDWebImage

final class StocksTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var logoImageView = AppImageView(type: .stackLogo)
    private lazy var titleLabel = AppLabel(type: .title)
    private lazy var subTitleLabel = AppLabel(type: .subtitle)

    private lazy var addToFavoriteButton = AddToFavButton()

    private lazy var rateLabel = AppLabel(type: .rate)
    private lazy var rateChangeLabel = AppLabel(type: .rateChange)

    private lazy var isFavoriteTextStack = AppStackView([titleLabel, addToFavoriteButton, UIView()], axis: .horizontal, spacing: 6)

    private lazy var textStack = AppStackView([isFavoriteTextStack, subTitleLabel], axis: .vertical, spacing: 5, alignment: .leading)

    private lazy var rateStack = AppStackView([rateLabel, rateChangeLabel], axis: .vertical, alignment: .trailing)

    private lazy var contentStack = AppStackView([logoImageView, textStack, rateStack], axis: .horizontal, spacing: 12, alignment: .center, distribution: .fill)

    private lazy var cellContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppConstants.Colors.gray
        view.layer.cornerRadius = AppConstants.CornerRadius.medium16
        view.clipsToBounds = true
        return view
    }()

    var onAddToFavButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension StocksTableViewCell {
    func configureCell(with stock: StockModel, isGray: Bool) {
        logoImageView.sd_setImage(with: URL(string: stock.logo))
        titleLabel.text = stock.symbol
        subTitleLabel.text = stock.name

        updateFavoriteButtonImage(stock)

        rateLabel.text = "$\(stock.price.cleanString)"
        updateChangeStockPrice(with: stock)

        cellContainer.backgroundColor = isGray ? AppConstants.Colors.brightGray : .clear


//        titleLabel.isOpaque = true
//        subTitleLabel.isOpaque = true
//        isFavoriteTextStack.isOpaque = true
//        textStack.isOpaque = true
//        contentStack.isOpaque = true
    }
}

// MARK: - Configure cell
private extension StocksTableViewCell {
    func setupCell() {
        contentView.addSubviews(cellContainer)

        cellContainer.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        cellContainer.setConstraints(insets: .init(top: AppConstants.Insets.small4, left: 0, bottom: AppConstants.Insets.small4, right: 0))

        contentStack.setConstraints(insets: .init(
            top: AppConstants.Insets.medium8,
            left: AppConstants.Insets.medium8,
            bottom: AppConstants.Insets.medium8,
            right: AppConstants.Insets.large12))

        textStack.widthAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.5).isActive = true
    }
}

// MARK: - Setup Action
private extension StocksTableViewCell {
    func setupAction() {
        addToFavoriteButton.onAddToFavButtonTapped = { [weak self] in
            self?.onAddToFavButtonTapped?()
        }
    }
}

// MARK: - Private methods
private extension StocksTableViewCell {
    func updateFavoriteButtonImage(_ stock: StockModel) {
        let image = stock.isFavorite ? "starGold" : "starGray"
        addToFavoriteButton.setImage(UIImage(named: image), for: .normal)
    }

    func updateChangeStockPrice(with stock: StockModel) {
        let changeText = "$\(abs(stock.change)) (\(abs(stock.changePercent))%)"

        if stock.change > 0 {
            rateChangeLabel.textColor = AppConstants.Colors.green
            rateChangeLabel.text = "+\(changeText)"
        } else {
            rateChangeLabel.textColor = AppConstants.Colors.red
            rateChangeLabel.text = "-\(changeText)"
        }
    }
}
