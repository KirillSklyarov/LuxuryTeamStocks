//
//  CategoryHeaderView.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 20.07.2025.
//

import UIKit

final class SearchHeaderView: UIView {

    private lazy var stockTitle = AppLabel(type: .title)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviews(stockTitle)
        stockTitle.setConstraints()
    }
}
