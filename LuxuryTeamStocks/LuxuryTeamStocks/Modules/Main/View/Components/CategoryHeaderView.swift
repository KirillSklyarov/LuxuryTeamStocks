//
//  CategoryHeaderView.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 20.07.2025.
//

import UIKit

final class CategoryHeaderView: UIView {

    private lazy var stockButton = AppButton(style: .stocks, isSelected: true)
    private lazy var favoriteButton = AppButton(style: .favourite, isSelected: false)

    private lazy var categoriesStackView = AppStackView([stockButton, favoriteButton, UIView()], axis: .horizontal, spacing: 20)

    var tabSelected: ((Int) -> Void)?


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //    func setupUI(_ isFavoriteChosen: Bool) -> UIView {
    func setupUI() {
        addSubviews(categoriesStackView)
        categoriesStackView.setConstraints()

        //        categoriesStackView.backgroundColor = .systemBackground

        stockButton.onButtonTapped = { [weak self] tag in
            guard let self = self else { return }
            stockButton.applySelectedStyle(true)
            favoriteButton.applySelectedStyle(false)
            tabSelected?(tag)
        }

        favoriteButton.onButtonTapped = { [weak self] tag in
            guard let self = self else { return }
            stockButton.applySelectedStyle(false)
            favoriteButton.applySelectedStyle(true)
            //            print(tag)
            tabSelected?(tag)
        }
    }
}
