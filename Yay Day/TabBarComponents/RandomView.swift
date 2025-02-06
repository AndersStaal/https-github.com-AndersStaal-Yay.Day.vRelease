//
//  RandomView.swift
//  Yay Day
//
//  Created by Anders Staal on 28/01/2025.
//


import SwiftUI
import Foundation
import CoreLocation



struct RandomEventModalView: View {
    @Environment(\.dismiss) private var dismiss // To close the modal
    @StateObject private var viewModel = RandomEventViewModel()
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @ObservedObject var translationManager = TranslationManager.shared
    @State private var isFavorite: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // Display event content if available
                if let event = viewModel.randomEvent {
                    VStack(alignment: .leading, spacing: 10) {
                        // NavigationLink to the event details page
                        NavigationLink(destination: EventInfoPage(event: event, userLocation: userLocation)) {
                            VStack(alignment: .leading, spacing: 10) {
                                // Event Image
                                if let url = URL(string: event.imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 200)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } placeholder: {
                                        ProgressView()
                                            .frame(height: 200)
                                    }
                                }

                                // Event Title
                                Text(event.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.top, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)


                                // Event Description
                                Text(event.translatedDescription)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading) // Ensures all lines align left



                                // Event Details
                                HStack {
                                    HStack(spacing: 5) {
                                        Image(systemName: "calendar")
                                        Text(formatDate(from: event.startDate) ?? "Unknown Date")
                                    }
                                    Spacer()
                                    HStack(spacing: 5) {
                                        Image(systemName: "mappin.and.ellipse")
                                        Text(event.place)
                                    }
                                }
                                .font(.subheadline)
                                .foregroundColor(.gray)

                                HStack {
                                    HStack(spacing: 5) {
                                        Image(systemName: "wallet.pass")
                                        Text("\(Int(event.price)) kr")
                                    }
                                    Spacer()
                                    Button(action: {
                                        withAnimation {
                                            isFavorite.toggle()
                                            toggleFavorite(event: event)
                                        }
                                    }) {
                                        Image(systemName: isFavorited(event: event) ? "heart.fill" : "heart")
                                            .foregroundColor(isFavorite ? .red : .gray)
                                            .font(.title2)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.white))

                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        }
                    }
                } else {
                    // Show a placeholder when no event is fetched
                    Text("Fetching event...")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()

                // "Get Another Event" Button
                Button(action: {
                    Task {
                        await viewModel.fetchRandomEvent()
                    }
                }) {
                    Text(translationManager.translate("GetAnotherEvent"))                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.7))

                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .onAppear {
                Task {
                    await viewModel.fetchRandomEvent()
                }
            }
            .navigationTitle("Random Event")
            .navigationBarTitleDisplayMode(.inline) // Centers title
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Random Event")
                        .font(.headline) // Adjust if needed
                        .padding(.top, 20)
                }
            }
           
            .background(Color(red: 0.99, green: 0.97, blue: 0.88))
            LocationManagerWrapper(userLocation: $userLocation)
                .frame(height: 0)

        }
        .background(Color(red: 0.99, green: 0.97, blue: 0.88))

    }
    
}


struct RoundedCorners18: Shape {
    var radius: CGFloat = 20
    var corners: UIRectCorner = [.topLeft, .topRight]
    
    func path(in rect: CGRect) -> Path {
        // Debug output
        
        let adjustedRadius = min(radius, min(rect.width, rect.height) / 2)
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: adjustedRadius, height: adjustedRadius)
        )
        return Path(path.cgPath)
    }
}


private func formatDate(from dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    if let date = dateFormatter.date(from: dateString) {
       
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "da_DK")
        
        return dateFormatter.string(from: date)
    }
    
    return nil
}
