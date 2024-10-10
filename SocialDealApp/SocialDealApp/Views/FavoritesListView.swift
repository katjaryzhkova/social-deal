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
                        .font(.title2)
                        .padding()
                        .navigationTitle("Favorites")
                } else {
                    // ScrollView with LazyVStack to match DealsListView
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(favoritesViewModel.favoriteDeals) { deal in
                                DealCard(deal: deal, onNavigate: {
                                    selectedDeal = deal
                                })
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                    .navigationTitle("Favorites")
                }

                // Hidden NavigationLink for programmatic navigation
                NavigationLink(
                    destination: selectedDeal != nil ? AnyView(DealDetailView(deal: selectedDeal!)) : AnyView(EmptyView()),
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
