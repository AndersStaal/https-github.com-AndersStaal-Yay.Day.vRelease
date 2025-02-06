//
//  SeeMoreView.swift
//  Yay Day
//
//  Created by Anders Staal on 26/09/2024.
//

import Foundation
import SwiftUI

struct AllEventsView: View {
    @ObservedObject var viewModel: EventViewModel

    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.97, blue: 0.88)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Alle begivenheder")
                    .font(.custom("Helvetica Neue", size: 28))
                    .fontWeight(.bold)
                    .padding(.vertical, -25)
                    .padding(.bottom, 10)
                    .offset(y: -25)
                                       

                List(viewModel.events) { event in
                    EventRowView(event: event)
                        .listRowBackground(Color(red: 0.99, green: 0.97, blue: 0.88))
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden) 
            }
            .onAppear {
                Task {
                    await viewModel.fetchEvents(from: "https://api.yayx.dk/event/eventFilterMain")
                }
            }
        }
    }
}
