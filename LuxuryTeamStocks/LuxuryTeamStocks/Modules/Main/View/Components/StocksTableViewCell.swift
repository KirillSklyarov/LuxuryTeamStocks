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
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        imageView.layer.cornerRadius = AppConstants.CornerRadius.medium
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel = AppLabel(type: .title)
    private lazy var subTitleLabel = AppLabel(type: .subtitle)

    private lazy var addToFavoriteButton = AddToFavButton()

    private lazy var rateLabel = AppLabel(type: .rate)
    private lazy var rateChangeLabel = AppLabel(type: .rateChange)

    private lazy var isFavoriteTextStack = AppStackView([titleLabel, addToFavoriteButton, UIView()], axis: .horizontal, spacing: 6)

    private lazy var textStack = AppStackView([isFavoriteTextStack, subTitleLabel], axis: .vertical, spacing: 5, alignment: .leading)

    private lazy var rateStack = AppStackView([rateLabel, rateChangeLabel], axis: .vertical, alignment: .trailing)

    private lazy var contentStack = AppStackView([logoImageView, textStack, rateStack], axis: .horizontal, spacing: 12, alignment: .center)

    var onAddToFavButtonTapped: (() -> Void)?

    private lazy var cellContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppConstants.Colors.gray
        view.layer.cornerRadius = AppConstants.CornerRadius.medium
        view.clipsToBounds = true
        return view
    }()

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
    }

    private func updateFavoriteButtonImage(_ stock: StockModel) {
        let image = stock.isFavorite ? "starGold" : "starGray"
        addToFavoriteButton.setImage(UIImage(named: image), for: .normal)
    }

    private func updateChangeStockPrice(with stock: StockModel) {
        let changeText = "$\(abs(stock.change)) (\(abs(stock.changePercent))%)"

        if stock.change > 0 {
            rateChangeLabel.textColor = AppConstants.Colors.green
            rateChangeLabel.text = "+\(changeText)"
        } else {
            rateChangeLabel.textColor = AppConstants.Colors.red
            rateChangeLabel.text = "-\(changeText)"
        }

    }

//    func isHideCheckmarkView(_ bool: Bool) {
//        checkView.alpha = bool ? 0 : 1
//    }
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
            right: AppConstants.Insets.large12
        )
        )
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
