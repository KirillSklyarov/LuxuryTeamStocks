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

    func setupUI() {
//        favoriteButton.backgroundColor = .systemBackground
//        stockButton.backgroundColor = .systemBackground
//        categoriesStackView.backgroundColor = .systemBackground
//        backgroundColor = .systemBackground

        setupBlending([categoriesStackView])

        addSubviews(categoriesStackView)
        categoriesStackView.setConstraints()

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

    func setupBlending(_ stacks: [UIStackView]) {
        stacks.forEach {
            $0.backgroundColor = .systemBackground
            $0.isOpaque = true
        }
    }
}
