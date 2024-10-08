import SwiftUI

struct DealsListView: View {
    @StateObject var viewModel = DealsViewModel()
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    var body: some View {
        NavigationView {
            List(viewModel.deals) { deal in
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
            .navigationTitle("Deals")
            .onAppear {
                viewModel.fetchDeals()
            }
        }
    }
}
