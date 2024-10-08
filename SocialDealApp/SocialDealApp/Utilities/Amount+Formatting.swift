import Foundation

extension Amount {
    func formatted(currencyCode: String) -> String {
        let amountInSelectedCurrency: Double
        let symbol: String
        
        if currencyCode == "USD" {
            amountInSelectedCurrency = (amount ?? 0) * 1.1 // Example conversion rate
            symbol = "$"
        } else {
            amountInSelectedCurrency = amount ?? 0
            symbol = "€"
        }
        
        let formattedAmount = amountInSelectedCurrency / 100
        return String(format: "\(symbol)%.2f", formattedAmount)
    }
}
