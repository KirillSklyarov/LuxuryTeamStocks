//
//  SearchView.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import UIKit

final class SearchView: UIView {

    private lazy var roundContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.setBorder(AppConstants.Colors.black, borderWidth: 1)
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return view
    }()

    private lazy var glassImageView = AppImageView(type: .glass)

    private let textField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Find company or ticker",
            attributes: [
                .foregroundColor: AppConstants.Colors.black,
                .font: AppConstants.Fonts.searchBar ?? .boldSystemFont(ofSize: 30)
            ])
        textField.font = AppConstants.Fonts.searchBar
        return textField
    }()

    private lazy var searchStackView = AppStackView([glassImageView, textField], axis: .horizontal, spacing: 10)


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundContainer.layer.cornerRadius = roundContainer.frame.height / 2
    }

    func setup() {
        configureGlassImageView()

        addSubviews(roundContainer)
        roundContainer.setConstraints()
    }

    func configureGlassImageView() {
        roundContainer.addSubviews(searchStackView)
        NSLayoutConstraint.activate([
            searchStackView.centerYAnchor.constraint(equalTo: roundContainer.centerYAnchor),
            searchStackView.leadingAnchor.constraint(equalTo: roundContainer.leadingAnchor, constant: 20)
        ])
    }
}
