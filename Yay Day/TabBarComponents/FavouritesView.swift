//
//  FavouritesView.swift
//  Yay Day
//
//  Created by Anders Staal on 13/09/2024.
//

import Foundation
import SwiftUI
import CoreLocation



struct FavouritesPage: View {
    var events: [Event]
    @State private var favouriteEvents: [Event] = []
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @State private var isFavorite: Bool = false

    let pastelDarkGreen = Color(red: 0.2, green: 0.5, blue: 0.3)
    let backgroundColor = Color(red: 0.99, green: 0.97, blue: 0.88)

    @ObservedObject var translationManager = TranslationManager.shared 

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text(translationManager.translate("Favoritter"))
                    .font(.custom("Helvetica Neue", size: 24))
                    .fontWeight(.bold) 
                    .foregroundStyle(Color.black)
                    .padding(.top, 60)
                    .padding(.bottom, 30)
                    .offset(y: 10)

                if favouriteEvents.isEmpty {
                    Text(translationManager.translate("Ingen_Favoritter"))
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(115)
                        .offset(y: -100)
                        .padding(.bottom, 300)
                } else {
                    ScrollView {
                        ForEach(favouriteEvents) { event in
                            VStack(spacing: 10) {
                               
                                    NavigationLink(destination: EventInfoPage(event: event, userLocation: userLocation)) {
                                        VStack(alignment: .center, spacing: 4) {
                                            if let url = URL(string: event.imageUrl) {
                                                AsyncImage(url: url) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 380, height: 170)
                                                        .shadow(color: Color.black.opacity(0.5), radius: 1, x: 1, y: 1)
                                                        .clipShape(RoundedCorners(radius: 10, corners: [.topLeft, .topRight]))
                                                        .overlay(
                                                            ZStack {
                                                                Color.gray.opacity(0.1)
                                                                    .frame(width: 380, height: 40)
                                                                    .clipShape(RoundedCorners(radius: 10, corners: [.topLeft, .topRight]))

                                                                HStack {
                                                                    Image(systemName: "calendar")
                                                                        .foregroundColor(.white)
                                                                        .padding(.top, 2)
                                                                        .font(.system(size: 20))
                                                                    Spacer()
                                                                    if let formattedDate = formatDate(from: event.startDate) {
                                                                        Text(formattedDate)
                                                                            .font(.custom("Helvetica Neue", size: 18))
                                                                            .fontWeight(.bold)
                                                                            .foregroundColor(.white)
                                                                            .multilineTextAlignment(.center)
                                                                            .tracking(1)
                                                                    } else {
                                                                        Text("Invalid Date")
                                                                            .font(.subheadline)
                                                                            .foregroundColor(.red)
                                                                    }
                                                                    Spacer() 
                                                                    Button(action: {
                                                                        withAnimation {
                                                                            isFavorite.toggle()
                                                                            toggleFavorite(event: event)
                                                                        }
                                                                    }) {
                                                                        Image(systemName: isFavorited(event: event) ? "heart.fill" : "heart")
                                                                            .foregroundColor(.white)
                                                                            .fontWeight(.semibold)
                                                                            .animation(.easeInOut, value: isFavorite)
                                                                            .font(.system(size: 20))
                                                                            .cornerRadius(15)
                                                                            .padding(.top, 2)
                                                                    }
                                                                }

                                                                .padding(.horizontal, 16)
                                                                .padding(.vertical, 4)
                                                                .padding(.top, 10)
                                                            },
                                                            alignment: .top
                                                        )
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                            }

                                            Text(event.title)
                                                .font(.custom("Helvetica Neue", size: 18))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black.opacity(0.9))

                                            Text(event.translatedDescription.prefix(60))
                                                .font(.system(size: 15))
                                                .foregroundColor(.black)
                                                .padding(.horizontal, 8)
                                                .offset(y: -2)
                                                .padding(.bottom, 15)

                                            HStack(spacing: 8) {
                                                HStack(spacing: 3) {
                                                    Image(systemName: "wallet.pass")
                                                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.3))
                                                        .offset(x: -4)

                                                    Text("\(Int(event.price)) kr")
                                                        .font(.subheadline)
                                                        .foregroundColor(.black.opacity(0.5))
                                                        .fontWeight(.semibold)
                                                }
                                                .offset(x: 3)
                                                Spacer()
                                                HStack(spacing: 3) {
                                                    Text(event.eventPlace!)
                                                        .font(.custom("Helvetica Neue", size: 16))
                                                        .fontWeight(.semibold)
                                                
                                                     
                                                    .foregroundColor(.black.opacity(0.5))
                                                    
                                                    Image(systemName: "globe")
                                                        .foregroundColor(.blue)
                                                }
                                            }
                                            .offset(y: -15)
                                            .padding(.horizontal, 10)

                                            HStack(spacing: 3) {
                                                Image(systemName: "tag.fill")
                                                    .foregroundColor(.orange)
                                                    .offset(x: -2)

                                                Text(translationManager.translate(event.categoryName))
                                                    .font(.custom("Helvetica Neue", size: 16))
                                                    .foregroundColor(.black.opacity(0.5))
                                                    .fontWeight(.semibold)
                                                    .offset(x: 1)
                                                Spacer()
                                                Text(event.place)
                                                    .font(.subheadline)
                                                    .offset(x: -4)
                                                    .foregroundColor(.black.opacity(0.5))
                                                    .fontWeight(.semibold)
                                                Image(systemName: "mappin.and.ellipse")
                                                    .foregroundColor(.red)
                                                    .offset(y: -3)
                                            }
                                            .padding(.horizontal, 10)
                                            .offset(y: -16)
                                        }
                                        .padding(.vertical, 1)
                                        .frame(width: 380, height: 260)
                                        .background(Color.orange.opacity(0.1))
                                        .cornerRadius(10)
                                        
                                    
                                }
                            }
                        }
                        .padding(.top, 10)
                        .buttonStyle(PlainButtonStyle())
                        LocationManagerWrapper(userLocation: $userLocation)
                            .frame(height: 0)
                    }
                    .overlay(
                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(Color.black.opacity(0.3)),
                        alignment: .top
                    )
                }
            }
            .padding(.bottom, 80)
            .background(backgroundColor)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                loadFavourites()
            }
        }

    }

    func loadFavourites() {
        let savedEventIDs = UserDefaults.standard.array(forKey: "favourites") as? [String] ?? []
        favouriteEvents = events.filter { savedEventIDs.contains($0.id) }
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

