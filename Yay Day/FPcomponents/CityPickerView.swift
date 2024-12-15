//
//  CityPickerView.swift
//  Yay Day
//
//  Created by Anders Staal on 08/11/2024.
//

import Foundation
import SwiftUI

struct CityPickerView: View {
    @ObservedObject var viewModel: EventViewModelCity
    @ObservedObject var translationManager = TranslationManager.shared 


    var body: some View {
        VStack { 
            HStack {
                Text(translationManager.translate("WhereGoing"))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("Helvetica Neue", size: 15))
                    .padding(.horizontal, 10)
                    .foregroundColor(.black)
                    .offset(x: 15)
                    .fontWeight(.semibold)

                Menu {
                    ForEach(viewModel.availableCities, id: \.self) { city in
                        Button(action: {
                            viewModel.selectedCity = city
                        }) {
                            Text(city)
                        }
                    }
                   
                } label: {
                    HStack {
                        Text(viewModel.selectedCity ?? "")
                        Image(systemName: "chevron.down")
                            .foregroundColor(.orange)
                            .offset(x: -10)
                    }
                }
            }
            .padding(.bottom, 30)

            NavigationLink(
                destination: CityEventsView(viewModel: viewModel, city: viewModel.selectedCity ?? "Alle"),
                isActive: Binding(
                    get: { viewModel.selectedCity != nil },
                    set: { if !$0 { viewModel.selectedCity = nil } }
                )
            ) { EmptyView() }
        }
    }
}

struct CityEventsView: View {
    @ObservedObject var viewModel: EventViewModelCity
    let city: String

    var body: some View {
            VStack {
                Text("\(city)")
                    .font(.custom("Helvetica Neue", size: 18))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.black)
                  
                
                ScrollView {
                    ForEach(viewModel.filteredEvents) { event in
                        EventCardView2(event: event)
                    }
                }
                .overlay(
                    Rectangle()
                        .frame(height: 3)
                        .foregroundColor(Color.black.opacity(0.3)),
                    alignment: .top
                )
            }
            
            .background(Color(red: 0.99, green: 0.97, blue: 0.88)) 
            .onAppear {
                Task {
                    await viewModel.fetchAllEvents()
                }
            }
            .background(Color(red: 0.99, green: 0.97, blue: 0.88))

        
        } 
    }
