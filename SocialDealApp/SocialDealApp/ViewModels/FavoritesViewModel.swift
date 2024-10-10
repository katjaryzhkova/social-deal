import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favoriteDeals: [Deal] = []

    private let favoritesKey = "favoriteDeals"

    init() {
        loadFavorites()
    }

    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([Deal].self, from: data) {
            self.favoriteDeals = decoded
        }
    }

    func addFavorite(deal: Deal) {
        if !favoriteDeals.contains(where: { $0.unique == deal.unique }) {
            favoriteDeals.insert(deal, at: 0) // Insert at the top
            saveFavorites()
        }
    }

    func removeFavorite(deal: Deal) {
        if let index = favoriteDeals.firstIndex(where: { $0.unique == deal.unique }) {
            favoriteDeals.remove(at: index)
            saveFavorites()
        }
    }

    func isFavorite(deal: Deal) -> Bool {
        favoriteDeals.contains(where: { $0.unique == deal.unique })
    }

    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteDeals) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
}
