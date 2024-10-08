import Foundation
import SwiftUI

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
        if !favoriteDeals.contains(deal) {
            favoriteDeals.append(deal)
            saveFavorites()
        }
    }
    
    func removeFavorite(deal: Deal) {
        if let index = favoriteDeals.firstIndex(of: deal) {
            favoriteDeals.remove(at: index)
            saveFavorites()
        }
    }
    
    func isFavorite(deal: Deal) -> Bool {
        return favoriteDeals.contains(deal)
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteDeals) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
}
