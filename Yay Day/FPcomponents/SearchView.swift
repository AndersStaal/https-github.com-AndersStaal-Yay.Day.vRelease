//
//  SearchView.swift
//  Yay Day
//
//  Created by Anders Staal on 14/11/2024.
//

import Foundation
import CoreLocation
import SwiftUI

struct SearchEventsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SearchEventViewModel()
    @State private var searchText: String = ""
    @State private var selectedPlaceOrCategory: String?
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @ObservedObject var translationManager = TranslationManager.shared
    @State private var isFavorite: Bool = false

    
     
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.99, green: 0.97, blue: 0.88)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    VStack {
                        TextField(translationManager.translate("SearchEventsOrCategory"), text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.horizontal, .top])
                            .onChange(of: searchText) { newValue in
                                if newValue.isEmpty {
                                    DispatchQueue.main.async {
                                        viewModel.events = []
                                        viewModel.searchResults = []
                                        selectedPlaceOrCategory = nil
                                    }
                                } else {
                                    Task {
                                        await viewModel.fetchEvents5(byPlaceOrCategory: newValue)
                                    }
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            if !viewModel.searchResults.isEmpty {
                                LazyVStack {
                                    ForEach(viewModel.searchResults, id: \.self) { result in
                                        Button(action: {
                                            selectedPlaceOrCategory = result
                                            
                                            DispatchQueue.main.async {
                                                viewModel.searchResults = [result]
                                                searchText = result
                                            }
                                            
                                            Task {
                                                await viewModel.fetchEventsForSelectedPlaceOrCategory(result)
                                            }
                                        }) {
                                            Text(result)
                                                .padding()
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            } else if !searchText.isEmpty {
                                Text("No matches found")
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                            
                            if let _ = selectedPlaceOrCategory {
                                
                               
                                    LazyVStack(spacing: 7) {
                                        
                                        ForEach(viewModel.events) { event in
                                            NavigationLink(destination: EventInfoPage(event: event, userLocation: userLocation)) {
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    if let url = URL(string: event.imageUrl) {
                                                        AsyncImage(url: url) { image in
                                                            image
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 380, height: 175)
                                                                .clipShape(RoundedCorners8(radius: 10, corners: [.topLeft, .topRight]))
                                                            
                                                                .overlay(
                                                                    ZStack {
                                                                        Color.gray.opacity(0.2)
                                                                            .frame(width: 380, height: 30)
                                                                            .clipShape(RoundedCorners8(radius: 10, corners: [.topLeft, .topRight]))
                                                                        
                                                                        
                                                                        
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
                                                                        
                                                                    }
                                                                    ,
                                                                    
                                                                    alignment: .top
                                                                )
                                                            
                                                        }
                                                        placeholder: {
                                                            ProgressView()
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    Text(event.title)
                                                        .font(.custom("Helvetica Neue", size: 18))
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.black.opacity(0.9))
                                                        .padding(.bottom, 3)
                                                        .padding(.horizontal, 8)
                                                        .multilineTextAlignment(.center)
                                                        .frame(maxWidth: .infinity, alignment: .center)
                                                    
                                                    Text(event.translatedDescription.prefix(60))
                                                    
                                                        .font(.system(size: 15))
                                                        .foregroundColor(.black)
                                                        .padding(.horizontal, 8)
                                                        .offset(y: -2)
                                                    
                                                    
                                                    
                                                    HStack(spacing: 8) {
                                                        HStack(spacing: 3) {
                                                            Image(systemName: "wallet.pass")
                                                                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.3))
                                                                .offset(x: -3)
                                                            
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
                                                                .offset(x: -3)
                                                            
                                                                .foregroundColor(.black.opacity(0.5))
                                                            
                                                            Image(systemName: "globe")
                                                                .foregroundColor(.blue)
                                                                .offset(y: -2)
                                                        }
                                                        
                                                    }
                                                    .padding(.horizontal, 10)
                                                    
                                                    HStack(spacing: 3) {
                                                        Image(systemName: "tag.fill")
                                                            .foregroundColor(.orange)
                                                            .offset(x: -2)
                                                        
                                                        Text(translationManager.translate(event.categoryName))
                                                            .font(.custom("Helvetica Neue", size: 16))
                                                            .foregroundColor(.black.opacity(0.5))
                                                            .fontWeight(.semibold)
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
                                                    
                                                    
                                                }
                                                
                                                .padding(.vertical, 1)
                                                .frame(width: 380, height: 260)
                                                .overlay(
                                                                RoundedRectangle(cornerRadius: 10) // Apply rounded border
                                                                    .stroke(Color.black.opacity(0.1), lineWidth: 1) // Border color and width
                                                            )
                                                            .background(
                                                                Color(red: 0.99, green: 0.97, blue: 0.88)
                                                                    .cornerRadius(10)
                                                            )
                                                        
                                            }
                                                
                                            
                                            .padding(.horizontal)
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                                LocationManagerWrapper(userLocation: $userLocation)
                                    .frame(height: 0)
                                
                            }
                        
                                .padding(.top, 20)
                        }
                        .navigationTitle(translationManager.translate("SearchEvents"))
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel") {
                                    dismiss()
                                }
                            }
                        }
                        
                    }
                    
                
            }
        }
    }
}


struct RoundedCorners8: Shape {
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
