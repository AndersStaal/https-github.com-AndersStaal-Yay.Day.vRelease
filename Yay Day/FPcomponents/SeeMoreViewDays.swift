//
//  SeeMoreViewDays.swift
//  Yay Day
//
//  Created by Anders Staal on 14/10/2024.
//

import Foundation
import SwiftUI

struct AllEventsView1: View {
    @ObservedObject var viewModel: EventViewModelDays
    @ObservedObject var translationManager = TranslationManager.shared
    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.97, blue: 0.88)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(translationManager.translate("EventsIdag"))
                    .font(.custom("Helvetica Neue", size: 24))
                    .fontWeight(.bold)
                    
                    .padding(.bottom, 10)
                    
                    .foregroundStyle(Color.black)
                                       

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
