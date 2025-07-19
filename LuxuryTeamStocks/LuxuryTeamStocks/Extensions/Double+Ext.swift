//
//  Double+Ext.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import Foundation

extension Double {
    var cleanString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = self.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
        return formatter.string(from: NSNumber(value: self)) ?? String(self)
    }
}

