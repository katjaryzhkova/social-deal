import SwiftUI

struct FavoritesListView: View {
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    var body: some View {
        NavigationView {
            if favoritesViewModel.favoriteDeals.isEmpty {
                Text("No favorites yet.")
                    .foregroundColor(.gray)
                    .navigationTitle("Favorites")
            } else {
                List(favoritesViewModel.favoriteDeals) { deal in
                    ZStack {
                        NavigationLink(destination: DealDetailView(uniqueID: deal.unique)
                                        .environmentObject(favoritesViewModel)) {
                            EmptyView()
                        }
                        .opacity(0)
                        DealRow(deal: deal)
                            .environmentObject(favoritesViewModel)
                    }
                }
                .navigationTitle("Favorites")
            }
        }
    }
}
