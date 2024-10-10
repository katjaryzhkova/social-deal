import Foundation

extension Amount {
    func formatted(currencyCode: String) -> String {
        guard let amount = amount else { return "" }
        let amountInSelectedCurrency: Double
        let symbol: String

        if currencyCode == "USD" {
            amountInSelectedCurrency = amount * 1.1 // Example conversion rate
            symbol = "$"
        } else {
            amountInSelectedCurrency = amount
            symbol = "€"
        }

        let formattedAmount = amountInSelectedCurrency / 100
        return String(format: "\(symbol)%.2f", formattedAmount)
    }
}
