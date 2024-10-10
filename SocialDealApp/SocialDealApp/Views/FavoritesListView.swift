import SwiftUI

struct FavoritesListView: View {
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @State private var selectedDeal: Deal? = nil

    var body: some View {
        NavigationView {
            ZStack {
                if favoritesViewModel.favoriteDeals.isEmpty {
                    // Empty State View
                    Text("No favorites yet.")
                        .foregroundColor(.gray)
                        .navigationTitle("Favorites")
                } else {
                    // List of Favorite Deals
                    List(favoritesViewModel.favoriteDeals) { deal in
                        DealCard(deal: deal, onNavigate: {
                            selectedDeal = deal
                        })
                        .listRowInsets(EdgeInsets())
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Favorites")
                }

                // Hidden NavigationLink for Programmatic Navigation
                NavigationLink(
                    destination: DealDetailView(),
                    isActive: Binding<Bool>(
                        get: { selectedDeal != nil },
                        set: { if !$0 { selectedDeal = nil } }
                    )
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
    }
}
