//
//  SeeMoreViewKom.swift
//  Yay Day
//
//  Created by Anders Staal on 15/10/2024.
//

import Foundation
import SwiftUI

struct AllEventsView3: View {
    @ObservedObject var viewModel: EventViewModelByCategory2
    @ObservedObject var translationManager = TranslationManager.shared
    
    
    
    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.97, blue: 0.88)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(translationManager.translate("Kommunen_tilbyder"))
                    .font(.custom("Helvetica Neue", size: 24))
                    .fontWeight(.bold)
                
                    .padding(.bottom, 10)
                
                    .foregroundStyle(Color.black)
                
                
                // Check if there are events available, otherwise use placeholder events
                if viewModel.events.isEmpty {
                    Text("No events available")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.events) { event in
                        EventRowView(event: event)
                            .listRowBackground(Color(red: 0.99, green: 0.97, blue: 0.88))
                    }
                    
                    .overlay(
                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(Color.black.opacity(0.3)),
                        alignment: .top
                    )
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}
