import Foundation

extension Amount {
    /// Formats the amount based on the selected currency code.
    func formatted(currencyCode: String) -> String {
        guard let amount = amount else { return "" }
        let amountInSelectedCurrency: Double
        let symbol: String

        if currencyCode == "USD" {
            if let exchangeRate = CurrencyConverter.shared.exchangeRate {
                amountInSelectedCurrency = (amount / 100) * exchangeRate // Convert cents to units and apply exchange rate
                symbol = "$"
            } else {
                // If exchange rate is not available, disable USD conversion
                return "N/A"
            }
        } else {
            amountInSelectedCurrency = amount / 100
            symbol = "€"
        }

        return String(format: "\(symbol)%.2f", amountInSelectedCurrency)
    }
}
