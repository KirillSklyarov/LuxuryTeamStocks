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
    private lazy var isFavoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return imageView
    }()

    private lazy var rateLabel = AppLabel(type: .rate)
    private lazy var rateChangeLabel = AppLabel(type: .rateChange)

    private lazy var isFavoriteTextStack = AppStackView([titleLabel, isFavoriteImageView, UIView()], axis: .horizontal, spacing: 6)

    private lazy var textStack = AppStackView([isFavoriteTextStack, subTitleLabel], axis: .vertical, spacing: 5, alignment: .leading)

    private lazy var rateStack = AppStackView([rateLabel, rateChangeLabel], axis: .vertical, alignment: .trailing)

    private lazy var contentStack = AppStackView([logoImageView, textStack, rateStack], axis: .horizontal, spacing: 12, alignment: .center)

    var onTaskStateChanged: (() -> Void)?

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
    func configureCell(with stock: StockModel, isGray: Bool = false) {
        logoImageView.sd_setImage(with: URL(string: stock.logo))
        titleLabel.text = stock.symbol
        subTitleLabel.text = stock.name
        isFavoriteImageView.image = UIImage(named: "StarGray")
        rateLabel.text = "$\(stock.price.cleanString)"
        updateChangeStockPrice(with: stock)

        cellContainer.backgroundColor = isGray ? AppConstants.Colors.brightGray : .clear

//        rateChangePercentLabel.backgroundColor = .red
//        rateChangeStack.setBorder(borderWidth: 1)

//        checkView.setState(stock.completed)
//        designCell(stock.completed)
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
