import SwiftUI

struct SettingsView: View {
    @AppStorage("currencyCode") var currencyCode: String = "EUR"

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
            }
            .navigationTitle("Settings")
        }
    }
}
