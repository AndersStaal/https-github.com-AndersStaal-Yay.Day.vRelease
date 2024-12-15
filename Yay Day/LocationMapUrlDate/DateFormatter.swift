//
//  DateFormatter.swift
//  Yay Day
//
//  Created by Anders Staal on 26/09/2024.
//

import Foundation

import SwiftUI



struct CustomDateFormatter {
    
    
    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

