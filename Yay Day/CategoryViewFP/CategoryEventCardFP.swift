//
//  CategoryEventCardFP.swift
//  Yay Day
//
//  Created by Anders Staal on 07/11/2024.
//

import Foundation

import SwiftUI

struct EventCardView1: View {
    let event: Event
    @ObservedObject var translationManager = TranslationManager.shared

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: event.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350, height: 200)
                    .cornerRadius(10)
            } placeholder: {
                Color.gray
                    .frame(width: 350, height: 200)
                    .cornerRadius(10)
            }
            
            Text(event.title)
                .font(.headline)
                .padding(.top, 5)
            
            Text(event.translatedDescription)

                .font(.subheadline)
                .padding(.top, 2)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.bottom, 10)
    }
}
