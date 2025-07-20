//
//  AppLabelType.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 20.07.2025.
//


import UIKit

enum AppImageViewType {
    case glass
//    case title
//    case subtitle
//    case rate
//    case rateChange
}

final class AppImageView: UIImageView {

    // MARK: - Init
    init(type: AppImageViewType) {
        super.init(frame: .zero)
        configure(type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AppImageView {
    func configure(_ type: AppImageViewType) {
        switch type {
        case .glass:
            image = UIImage(named: "glass")
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: 16).isActive = true
            widthAnchor.constraint(equalToConstant: 16).isActive = true

//        case .title:
//            font = AppConstants.Fonts.regular
//            textColor = AppConstants.Colors.black
//        case .subtitle:
//            font = AppConstants.Fonts.body
//            textColor = AppConstants.Colors.black
//            self.numberOfLines = numberOfLines
//        case .rate:
//            font = AppConstants.Fonts.regular
//            textColor = AppConstants.Colors.black
//        case .rateChange:
//            font = AppConstants.Fonts.body
//            textColor = AppConstants.Colors.black
//            textAlignment = .right
        }
//        self.numberOfLines = numberOfLines
    }
}
