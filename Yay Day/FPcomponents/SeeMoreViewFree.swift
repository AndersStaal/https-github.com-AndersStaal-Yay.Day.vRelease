//
//  SeeMoreViewFree.swift
//  Yay Day
//
//  Created by Anders Staal on 18/11/2024.
//




import Foundation
import SwiftUI
import Combine

struct AllEventsView5: View {
    @ObservedObject var viewModel: FreeEventsViewModel
    @ObservedObject var translationManager = TranslationManager.shared
    
    
    
    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.97, blue: 0.88)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(translationManager.translate("FreeEvents"))
                    .font(.custom("Helvetica Neue", size: 24))
                    .fontWeight(.bold)
                
                    .padding(.bottom, 10)
                    .foregroundStyle(Color.black)
                
                
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
