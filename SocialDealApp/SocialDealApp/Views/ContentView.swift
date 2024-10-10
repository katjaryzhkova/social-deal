import SwiftUI

struct ContentView: View {
    @StateObject var favoritesViewModel = FavoritesViewModel()

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
    }
}
