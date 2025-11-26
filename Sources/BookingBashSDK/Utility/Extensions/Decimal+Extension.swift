//
//  Decimal+Extension.swift
//  VisaActivity
//
//

import Foundation

extension Decimal {
    func rounded(_ scale: Int = 0, rule: RoundingMode = .plain) -> Decimal {
        var value = self
        var result = Decimal()
        NSDecimalRound(&result, &value, scale, rule)
        return result
    }
}
