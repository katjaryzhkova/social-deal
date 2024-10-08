import SwiftUI

struct ContentView: View {
    @StateObject var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        TabView {
            DealsListView()
                .environmentObject(favoritesViewModel)
                .tabItem {
                    Label("Deals", systemImage: "list.dash")
                }
            FavoritesListView()
                .environmentObject(favoritesViewModel)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    ContentView()
}
