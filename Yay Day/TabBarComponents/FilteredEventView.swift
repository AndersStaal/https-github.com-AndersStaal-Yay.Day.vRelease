//
//  FilteredEventView.swift
//  Yay Day
//
//  Created by Anders Staal on 26/09/2024.
//

import Foundation

import SwiftUI
import CoreLocation


struct FilteredEventsView: View {
    let filteredEvents: [Event]
    @State private var userLocation: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationView {
            ZStack { 
                Color(red: 0.99, green: 0.97, blue: 0.88)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Filtrerede Events")
                        .font(.custom("Helvetica Neue", size: 24))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                        .padding(.bottom, 20)
                        .background(Color(red: 0.99, green: 0.97, blue: 0.88)) 
                    
                    if filteredEvents.isEmpty {
                        Text("Ingen resultater fundet.")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                    } else {
                        ScrollView {
                            
                            VStack(spacing: 10) {
                                ForEach(filteredEvents) { event in
                                    EventRowView2(event: event)
                                }
                                
                                
                            }
                            .padding(.top, 5)
                            .offset(y: 5)
                        }
                        
                        
                        .overlay(
                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(Color.black.opacity(0.3)),
                            alignment: .top 
                        )
                    }
                }
            }
            
            
            
            .buttonStyle(PlainButtonStyle())
            
            
            
            LocationManagerWrapper(userLocation: $userLocation)
                .frame(height: 0)
            
            
        }

        
    }

}
