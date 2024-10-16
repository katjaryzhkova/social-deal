import SwiftUI

/// A view that represents a single deal card, displaying deal information, image, and favorite status.
struct DealCard: View {
    let deal: Deal
    var onNavigate: (() -> Void)? = nil

    @AppStorage("currencyCode") private var currencyCode: String = "EUR"
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @ObservedObject private var currencyConverter = CurrencyConverter.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Deal Image and Favorite Button
            ZStack(alignment: .bottomTrailing) {
                DealImageView(imagePath: deal.image, onNavigate: onNavigate)

                FavoriteButton(isFavorite: favoritesViewModel.isFavorite(deal: deal)) {
                    toggleFavorite()
                }
                .padding(12)
                .zIndex(1)
            }

            // Deal Information
            VStack(alignment: .leading, spacing: 4) {
                Text(deal.title ?? "No Title")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)

                Text(deal.company ?? "No Company")
                    .foregroundColor(.gray)

                Text(deal.city ?? "No City")
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)

                PricingView(prices: deal.prices, deal: deal, currencyCode: currencyCode)
            }
            .padding([.horizontal, .bottom])
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }

    private func toggleFavorite() {
        if favoritesViewModel.isFavorite(deal: deal) {
            favoritesViewModel.removeFavorite(deal: deal)
        } else {
            favoritesViewModel.addFavorite(deal: deal)
        }
    }
}

/// A view that handles displaying the deal's image.
/// It can optionally handle navigation when the image is tapped.
struct DealImageView: View {
    let imagePath: String?
    var onNavigate: (() -> Void)? = nil

    var body: some View {
        Group {
            if let imagePath = imagePath, !imagePath.isEmpty {
                let imageURL = URL(string: "https://images.socialdeal.nl\(imagePath)")
                if let onNavigate = onNavigate {
                    Button(action: onNavigate) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(8)
                            case .failure(_):
                                Color.gray
                                    .cornerRadius(8)
                            default:
                                ProgressView()
                                    .frame(height: 200)
                            }
                        }
                        .frame(height: 200)
                        .clipped()
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(8)
                        case .failure(_):
                            Color.gray
                                .cornerRadius(8)
                        default:
                            ProgressView()
                                .frame(height: 200)
                        }
                    }
                    .frame(height: 200)
                    .clipped()
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(8)
            }
        }
    }
}

struct FavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
        }
        .contentShape(Circle())
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
    }
}

/// A view that displays pricing information, including sold label and prices.
/// Handles formatting based on the selected currency.
struct PricingView: View {
    let prices: Prices?
    let deal: Deal
    let currencyCode: String

    var body: some View {
        HStack {
            Text(deal.sold_label ?? "")
                .foregroundColor(.cyan)
            Spacer()
            if let fromPrice = prices?.from_price?.formatted(currencyCode: currencyCode) {
                Text(fromPrice)
                    .strikethrough()
                    .foregroundColor(.gray)
            }
            if let price = prices?.price?.formatted(currencyCode: currencyCode) {
                if price != "N/A" {
                    PriceText(price: price)
                } else {
                    Text("Price unavailable")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

/// A view that formats and displays the price by splitting it into whole and fractional parts.
/// Enhances the visual presentation of pricing.
struct PriceText: View {
    let price: String

    var body: some View {
        let fractionalPart = String(price.suffix(3))
        let wholePart = String(price.dropLast(3))

        HStack(alignment: .center, spacing: 0) {
            Text(wholePart)
                .font(.title)
                .foregroundColor(.green)

            Text(fractionalPart)
                .font(.title3)
                .foregroundColor(.green)
        }
    }
}
