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
    private lazy var logoImageView = UIImageView()
    private lazy var titleLabel = AppLabel(type: .title)
    private lazy var subTitleLabel = AppLabel(type: .subtitle)
    private lazy var isFavoriteImageView = UIImageView()
    private lazy var rateLabel = AppLabel(type: .rate)
    private lazy var rateChangeLabel = AppLabel(type: .rateChange)
    private lazy var rateChangePercentLabel = AppLabel(type: .rateChange)

    private lazy var isFavoriteTextStack = AppStackView([titleLabel, isFavoriteImageView], axis: .horizontal, spacing: 6)

    private lazy var textStack = AppStackView([isFavoriteTextStack, subTitleLabel], axis: .vertical)

    private lazy var rateChangeStack = AppStackView([rateChangeLabel, rateChangePercentLabel], axis: .horizontal, spacing: 5)

    private lazy var rateStack = AppStackView([rateLabel, rateChangeStack], axis: .vertical)

    private lazy var contentStack = AppStackView([logoImageView, textStack, rateStack], axis: .horizontal, spacing: 12)

//    private var titleTextHere = ""
    var onTaskStateChanged: (() -> Void)?

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
    func configureCell(with stock: StockModel) {
        logoImageView.sd_setImage(with: URL(string: stock.logo))
        titleLabel.text = stock.name
        subTitleLabel.text = stock.name
        isFavoriteImageView.image = UIImage(named: "starGray")
        rateLabel.text = "$ \(stock.price)"
        rateChangeLabel.text = "+$ \(stock.change)"
        rateChangePercentLabel.text = "\(stock.changePercent)%"

//        checkView.setState(stock.completed)
//        designCell(stock.completed)
    }

//    func isHideCheckmarkView(_ bool: Bool) {
//        checkView.alpha = bool ? 0 : 1
//    }
}

// MARK: - Configure cell
private extension StocksTableViewCell {
    func setupCell() {
//        backgroundColor = AppConstants.Colors.black
        contentView.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        contentStack.setConstraints(allInsets: AppConstants.Insets.small)

//        NSLayoutConstraint.activate([
//            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppConstants.Insets.small),
//            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppConstants.Insets.small)
//        ])
    }
}

// MARK: - Setup Action
private extension StocksTableViewCell {
    func setupAction() {
//        checkView.onDoneButtonTapped = { [weak self] isDone in
//            self?.designCell(isDone)
//            self?.onTaskStateChanged?()
//        }
    }

//    func designCell(_ isDone: Bool) {
//        isDone ? designDoneTaskCell() : designUndoneTaskCell()
//    }

//    func designDoneTaskCell() {
//        titleLabel.textColor = AppConstants.Colors.gray
//        subTitleLabel.textColor = AppConstants.Colors.gray
//        let attributedString = NSAttributedString(
//            string: titleTextHere,
//            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
//        titleLabel.attributedText = attributedString
//    }

//    func designUndoneTaskCell() {
//        titleLabel.textColor = AppConstants.Colors.white
//        subTitleLabel.textColor = AppConstants.Colors.white
//        titleLabel.attributedText = nil
//        titleLabel.text = titleTextHere
//    }
}
