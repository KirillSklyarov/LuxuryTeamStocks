//
//  AppLabelType.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import UIKit

enum AppLabelType {
    case category
    case title
    case subtitle
    case rate
    case rateChange
}

final class AppLabel: UILabel {

    // MARK: - Init
    init(type: AppLabelType, numberOfLines: Int = 0) {
        super.init(frame: .zero)
        configure(type, numberOfLines: numberOfLines)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AppLabel {
    func configure(_ type: AppLabelType, numberOfLines: Int) {
        switch type {
        case .category:
            font = AppConstants.Fonts.headline
            textColor = AppConstants.Colors.black
        case .title:
            font = AppConstants.Fonts.regular
            textColor = AppConstants.Colors.black
        case .subtitle:
            font = AppConstants.Fonts.body
            textColor = AppConstants.Colors.black
        case .rate:
            font = AppConstants.Fonts.regular
            textColor = AppConstants.Colors.black
        case .rateChange:
            font = AppConstants.Fonts.body
            textColor = AppConstants.Colors.black
        }
        self.numberOfLines = numberOfLines
    }
}
