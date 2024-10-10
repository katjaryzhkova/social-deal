import SwiftUI

struct ContentView: View {
    @StateObject var favoritesViewModel = FavoritesViewModel()
    @StateObject var currencyConverter = CurrencyConverter.shared
    @State private var showAlert = false

    var body: some View {
        TabView {
            DealsListView()
                .tabItem {
                    Label("Deals", systemImage: "list.dash")
                }
            FavoritesListView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .environmentObject(favoritesViewModel)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(currencyConverter.errorMessage ?? "An error occurred."), dismissButton: .default(Text("OK")))
        }
        .onReceive(currencyConverter.$errorMessage) { errorMessage in
            if errorMessage != nil {
                showAlert = true
            }
        }
    }
}
