import SwiftUI

struct DealsListView: View {
    @StateObject var viewModel = DealsViewModel()
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @State private var selectedDeal: Deal? = nil

    var body: some View {
        NavigationView {
            ZStack {
                // Main Content
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.deals) { deal in
                            DealCard(deal: deal, onNavigate: {
                                selectedDeal = deal
                            })
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                        }
                    }
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
            .navigationTitle("Deals")
            .onAppear {
                viewModel.fetchDeals()
            }
        }
    }
}
