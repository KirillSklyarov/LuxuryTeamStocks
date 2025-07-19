//
//  AppAlert.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//


import UIKit

final class AppAlert {
    static func create() -> UIAlertController {
        let alert = UIAlertController(title: AppConstants.alertsError.loadingError, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        return alert
    }
}
