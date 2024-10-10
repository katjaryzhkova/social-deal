import SwiftUI

struct DealCard: View {
    let deal: Deal
    var onNavigate: (() -> Void)? = nil
    @AppStorage("currencyCode") var currencyCode: String = "EUR"
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @ObservedObject var currencyConverter = CurrencyConverter.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                // Image wrapped in a Button to trigger navigation
                if let imagePath = deal.image, !imagePath.isEmpty {
                    if let onNavigate = onNavigate {
                        Button(action: {
                            onNavigate()
                        }) {
                            AsyncImage(url: URL(string: "https://images.socialdeal.nl\(imagePath)")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(8)
                                } else if phase.error != nil {
                                    Color.gray
                                        .cornerRadius(8)
                                } else {
                                    ProgressView()
                                        .frame(height: 200)
                                }
                            }
                            .frame(height: 200)
                            .clipped()
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        // Just display image without navigation
                        AsyncImage(url: URL(string: "https://images.socialdeal.nl\(imagePath)")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(8)
                            } else if phase.error != nil {
                                Color.gray
                                    .cornerRadius(8)
                            } else {
                                ProgressView()
                                    .frame(height: 200)
                            }
                        }
                        .frame(height: 200)
                        .clipped()
                        .contentShape(Rectangle())
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .cornerRadius(8)
                }

                // Favorite Button on top with higher zIndex
                Button(action: {
                    toggleFavorite()
                }) {
                    Image(systemName: favoritesViewModel.isFavorite(deal: deal) ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.6)) // Not according to provided wireframe, but otherwise the icon is hard to see sometimes
                        .clipShape(Circle())
                }
                .padding(12)
                .zIndex(1)
                .contentShape(Circle())
                .accessibilityLabel(favoritesViewModel.isFavorite(deal: deal) ? "Remove from favorites" : "Add to favorites")
            }

            // Deal information
            VStack(alignment: .leading, spacing: 4) {
                // Deal title
                Text(deal.title ?? "No Title")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)

                // Company name
                Text(deal.company ?? "No Company")
                    .foregroundColor(.gray)

                // Location
                Text(deal.city ?? "No City")
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)

                // Sold label and pricing
                HStack {
                   Text(deal.sold_label ?? "")
                       .foregroundColor(.cyan)
                   Spacer()
                   // Pricing
                   if let fromPrice = deal.prices?.from_price?.formatted(currencyCode: currencyCode) {
                       Text(fromPrice)
                           .strikethrough()
                           .foregroundColor(.gray)
                   }
                   if let price = deal.prices?.price?.formatted(currencyCode: currencyCode) {
                       if price != "N/A" {
                           // Extract the last three characters (comma and cents)
                           let fractionalPart = String(price.suffix(3))
                           // Extract the rest of the price (currency symbol and whole number)
                           let wholePart = String(price.dropLast(3))

                           HStack(alignment: .center, spacing: 0) {
                               // Currency and whole number part
                               Text(wholePart)
                                   .font(.title)
                                   .foregroundColor(.green)

                               // Fractional part (comma and cents)
                               Text(fractionalPart)
                                   .font(.title3)
                                   .foregroundColor(.green)
                           }
                       } else {
                           Text("Price unavailable")
                               .foregroundColor(.gray)
                       }
                   }
               }
           }
           .padding([.horizontal, .bottom])
       }
       .background(Color.white)
       .cornerRadius(8)
       .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
   }

    func toggleFavorite() {
        if favoritesViewModel.isFavorite(deal: deal) {
            favoritesViewModel.removeFavorite(deal: deal)
        } else {
            favoritesViewModel.addFavorite(deal: deal)
        }
    }
}
