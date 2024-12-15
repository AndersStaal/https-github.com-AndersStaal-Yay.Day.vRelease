//
//  HorizontalEventViewTop.swift
//  Yay Day
//
//  Created by Anders Staal on 28/11/2024.
//

import Foundation

import SwiftUI
import CoreLocation
import Combine

struct HorizontalEventViewTop: View {
    var events: [Event]
    @State private var isFavorite: Bool = false
    @ObservedObject var translationManager = TranslationManager.shared
    
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @State private var currentPage: Int = 0 
    
    
    let pastelDarkGreen = Color(red: 0.2, green: 0.5, blue: 0.3)
    
    var body: some View {
        VStack {
            ZStack {
                

                Divider()
                    .frame(width: 280, height: 3)
                    .background(Color.orange.opacity(0.3))
                
                Divider()
                    .frame(width: 280, height: 1)
                    .background(Color.black.opacity(0.3))
                    .offset(y: 2)
            }
            .offset(x: -5)
                   
                
            TabView(selection: $currentPage) {
                ForEach(0..<events.count, id: \.self) { index in
                    let event = events[index]
                    eventCard(event: event)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .frame(height: 243)
            ZStack {
                

                Divider()
                    .frame(width: 280, height: 3)
                    .background(Color.orange.opacity(0.3))
                
                Divider()
                    .frame(width: 280, height: 1)
                    .background(Color.black.opacity(0.3))
                    .offset(y: 2)
            }
            .offset(x: -3)
                   
            
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.white.opacity(0.1))
                UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.white.opacity(0.1))
            }
            
            
            HStack(spacing: 8) {
                let currentSetIndex = currentPage / 5
                let startIndex = currentSetIndex * 5
                let endIndex = min(startIndex + 5, events.count)
                
                ForEach(startIndex..<endIndex, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.orange : Color.black.opacity(0.2))
                        .frame(width: 8, height: 8)
                }
            }
            
        }
        .onChange(of: currentPage) { newValue in
            if newValue >= events.count {
                currentPage = 0
            }
        }
        
    }


   
    
    private func eventCard(event: Event) -> some View {
        
        NavigationLink(destination: EventInfoPage(event: event, userLocation: userLocation)) {
            
            
                
                        
                    VStack(alignment: .center, spacing: 5) {
                        if let url = URL(string: event.imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 360, height: 170)
                                    .clipped()
                                  
                                    .clipShape(RoundedCorners2(radius: 10, corners: [.topLeft, .topRight]))
                                    .overlay(
                                        ZStack {
                                            Color.gray.opacity(0.1)
                                                .frame(width: 360, height: 27)
                                                .clipShape(RoundedCorners2(radius: 10, corners: [.topLeft, .topRight]))
                                               .offset(y: -3)
                                            
                                                
                                            HStack {
                                                Image(systemName: "calendar")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 22))
                                                    
                                                
                                                Spacer()
                                                
                                                if let formattedDate = formatDate(from: event.startDate) {
                                                    Text(formattedDate)
                                                        .font(.custom("Helvetica Neue", size: 18))
                                                        .tracking(1)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.white)
                                                        .multilineTextAlignment(.center)
                                                        
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
                                                        .font(.system(size: 22))
                                                        .animation(.easeInOut, value: isFavorite)
                                                       
                                                }
                                            }
                                            .padding(.horizontal, 10)
                                            
                                        },
                                        alignment: .top
                                    )
                            } placeholder: {
                                ProgressView()
                            }
                        }
                         
                        
                            Text(event.title)
                                .font(.custom("Helvetica Neue", size: 16))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.black.opacity(0.9))
                               
                                .padding(.horizontal, 3)

                            
                            Text(event.translatedDescription.prefix(60))
                                .font(.custom("Helvetica Neue", size: 14))
                                .foregroundColor(.black.opacity(0.9))
                                .padding(.horizontal, 2)

                            
                        
                        
                        HStack(spacing: 20) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.red.opacity(0.9))
                                    .offset(y: -4)
                                    .padding(.horizontal, 3)
                                    .fontWeight(.semibold)

                                    
                                    Text(event.place)
                                    .font(.custom("Helvetica Neue", size: 15))
                                    .foregroundColor(.black.opacity(0.55))
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .offset(x: -5)
                                    .offset(y: -2)

                            }
                            HStack {
                                Image(systemName: "wallet.pass")
                                    .foregroundColor(pastelDarkGreen)
                                    .offset(y: -2)
                                    .fontWeight(.semibold)

                                Text("\(Int(event.price)) kr")
                                    .font(.custom("Helvetica Neue", size: 15))
                                    .foregroundColor(.black.opacity(0.55))
                                    .fontWeight(.semibold)
                                    .offset(x: -4)
                                    .offset(y: -2)
                            }
                        }
                    }
                    .frame(width: 360, height: 240)
                    
                   
                

                .toolbar(.hidden)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                LocationManagerWrapper(userLocation: $userLocation)
                    .frame(height: 0)
            
        }
        .padding(.horizontal, 15)

        
    }
    


struct RoundedCorners2: Shape {
    var radius: CGFloat = 20
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


private func dateString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
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
 
func toggleFavorite(event: Event) {
    var savedEventIDs = UserDefaults.standard.array(forKey: "favourites") as? [String] ?? []
    if isFavorited(event: event) {
        savedEventIDs.removeAll { $0 == event.id }
    } else {
        savedEventIDs.append(event.id)
    }
    UserDefaults.standard.set(savedEventIDs, forKey: "favourites")
}

func isFavorited(event: Event) -> Bool {
    let savedEventIDs = UserDefaults.standard.array(forKey: "favourites") as? [String] ?? []
    return savedEventIDs.contains(event.id)
}

}
