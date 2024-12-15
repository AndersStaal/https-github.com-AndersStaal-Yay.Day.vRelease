//
//  CategoryButton.swift
//  Yay Day
//
//  Created by Anders Staal on 26/09/2024.
//

import Foundation
import SwiftUI

struct CategoryButton: View {
    let category: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
            Button(action: {
                onTap()
            }) {
                Text(category)
                    .font(.subheadline)
                    .padding(10)
                    .foregroundColor(isSelected ? .white : .black)
                    .frame(width: 110, height: 40)
                    .background(isSelected ? Color.orange.opacity(0.7) : Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9) 
            }
        }
    }
