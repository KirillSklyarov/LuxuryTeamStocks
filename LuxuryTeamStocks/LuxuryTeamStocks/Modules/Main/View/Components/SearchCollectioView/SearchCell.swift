//
//  TagCell.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 20.07.2025.
//


import UIKit

final class SearchCell: UICollectionViewCell {

    private lazy var label = AppLabel(type: .searchRequest)

    var onLabelTapped: ((String) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with text: String) {
        label.text = text
    }

    private func setupUI() {
        contentView.layer.cornerRadius = AppConstants.CornerRadius.large20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = AppConstants.Colors.brightGray
        contentView.addSubviews(label)

        label.setConstraints(insets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        let tap = UITapGestureRecognizer(target: self, action: #selector(ButtonTapped))
        addGestureRecognizer(tap)
    }

    @objc private func ButtonTapped() {
        let stockName = label.text ?? ""
        onLabelTapped?(stockName)
    }
}
