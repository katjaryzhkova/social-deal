import SwiftUI

struct SettingsView: View {
    @AppStorage("currencyCode") var currencyCode: String = "EUR"
    @ObservedObject var currencyConverter = CurrencyConverter.shared

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Currency")) {
                    Picker("Currency", selection: $currencyCode) {
                        Text("Euros (€)").tag("EUR")
                        Text("Dollars ($)").tag("USD")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                if currencyCode == "USD" {
                    Section(header: Text("Exchange Rate")) {
                        if let lastUpdated = currencyConverter.lastUpdated {
                            Text("Last updated: \(formattedDate(lastUpdated))")
                        } else {
                            Text("Exchange rate not available.")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
