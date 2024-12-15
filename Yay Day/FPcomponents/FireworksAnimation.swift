//
//  FireworksAnimation.swift
//  Yay Day
//
//  Created by Anders Staal on 04/12/2024.
//

import Foundation

import SwiftUI

struct FireworksAnimation: View {
    var animate: Bool 

    var body: some View {  
           ZStack {
               createCircle(color: .red, x: 450, y: -450, scale: 3)
               createCircle(color: .purple, x: 650, y: -300, scale: 3)
               createCircle(color: .pink, x: 300, y: -400, scale: 2.5)
               createCircle(color: .blue, x: 450, y: -450, scale: 3)
               createCircle(color: .blue, x: -350, y: -400, scale: 3)
               createCircle(color: .red, x: -250, y: -350, scale: 3)
               createCircle(color: .pink, x: -150, y: -350, scale: 2.5)
               createCircle(color: .blue, x: -300, y: -400, scale: 3)
               createCircle(color: .red, x: -200, y: -450, scale: 3)
               createCircle(color: .purple, x: 350, y: -300, scale: 3)
               createCircle(color: .blue, x: 200, y: -450, scale: 3)
               createCircle(color: .pink, x: -150, y: -350, scale: 2.5)
               createCircle(color: .purple, x: 150, y: -350, scale: 2.5)
               createCircle(color: .yellow, x: 0, y: -500, scale: 2.8)
               createCircle(color: .purple, x: 550, y: -300, scale: 3)
               createCircle(color: .pink, x: 500, y: -400, scale: 2.5)
               createCircle(color: .red, x: 450, y: -450, scale: 3)
               createCircle(color: .purple, x: 650, y: -300, scale: 3)
               createCircle(color: .pink, x: 300, y: -400, scale: 2.5)
               createCircle(color: .blue, x: 450, y: -450, scale: 3)
               createCircle(color: .blue, x: -350, y: -400, scale: 3)
               createCircle(color: .red, x: -250, y: -350, scale: 3)
               createCircle(color: .pink, x: -150, y: -350, scale: 2.5)
               createCircle(color: .purple, x: 150, y: -350, scale: 2.5)
               createCircle(color: .pink, x: -150, y: -350, scale: 2.5)
               createCircle(color: .purple, x: 150, y: -350, scale: 2.5)
               createCircle(color: .yellow, x: 0, y: -500, scale: 2.8)
               createCircle(color: .purple, x: 550, y: -300, scale: 3)
           }
       } 
 
       private func createCircle(color: Color, x: CGFloat, y: CGFloat, scale: CGFloat) -> some View {
           Circle()
               .fill(color.opacity(0.7))
               .frame(width: 10, height: 10)
               .offset(x: animate ? x : 0, y: animate ? y : 50)
               .scaleEffect(animate ? scale : 1.0)
               .opacity(animate ? 0 : 1)
               .animation(
                   Animation.easeOut(duration: 0.8)
                       .repeatForever(autoreverses: false),
                   value: animate
               )
       }
   }
