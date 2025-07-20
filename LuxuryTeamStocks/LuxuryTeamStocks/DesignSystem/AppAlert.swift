//
//  AppAlert.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//


import UIKit

final class AppAlert {
    static func create(retryHandler: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: AppConstants.alertsError.loadingError, message: "", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(cancelAction)

        let retry = UIAlertAction(title: "Повторить", style: .default) { _ in
            retryHandler()
        }
        alert.addAction(retry)

        return alert
    }
}
