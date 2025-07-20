//
//  CollectionHeaderView.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 20.07.2025.
//


import UIKit

final class CollectionHeaderView: UICollectionReusableView {

    // MARK: - Properties
    static let reuseIdentifier = "CollectionHeaderView"
    private let label = AppLabel(type: .searchHeader)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public methods
    func configure(text: String) {
        label.text = text
    }

    private func setupUI() {
        addSubviews(label)
        label.setConstraints(insets: UIEdgeInsets(top: 0, left: 20, bottom: 11, right: 20))
    }
}
