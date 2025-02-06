//
//  SettingsPage.swift
//  Yay Day
//
//  Created by Anders Staal on 25/09/2024.
//

import SwiftUI

struct SettingsPage: View {
    @State private var notificationsEnabled: Bool = true
    @ObservedObject var translationManager = TranslationManager.shared
    let languages = ["en": "English", "da": "Dansk"]
    
    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.97, blue: 0.88)
                .edgesIgnoringSafeArea(.all)
            
            
                VStack(spacing: 20) { // Add spacing between sections
                    
                    // Language and Notifications Form
                    Form {
                        Section(header: Text(translationManager.translate("language"))
                            .foregroundColor(.black)) {
                                Picker(translationManager.translate("language"),
                                       selection: $translationManager.selectedLanguage) {
                                    ForEach(languages.keys.sorted(), id: \.self) { lang in
                                        Text(languages[lang] ?? lang).tag(lang)
                                    }
                                }
                                .onChange(of: translationManager.selectedLanguage) { newLanguage in
                                    TranslationManager.shared.updateLanguage(newLanguage)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.vertical)
                        }
                        
                        Section(header: Text(translationManager.translate("Notifications"))
                            .foregroundColor(.black)) {
                                Toggle(translationManager.translate("Enable Notifications"), isOn: $notificationsEnabled)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.99, green: 0.97, blue: 0.88))
                    .cornerRadius(10)
                    .scrollContentBackground(.hidden)
                    
                    
                    
                        
                        
                        Text("Følg Yay Days sociale medier for konkurrencer, seneste nyt fra den danske eventscene og meget mere!")
                            .font(.custom("Helvetica Neue", size: 20))
                            .foregroundColor(.orange.opacity(0.75))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    
                    
                    // Social Media Buttons
                    HStack(spacing: 50) {
                        Button(action: {
                            if let url = URL(string: "https://www.facebook.com/YayDay") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "globe") // Replace with custom Facebook icon
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: {
                            if let url = URL(string: "https://www.instagram.com/YayDay") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "camera") // Replace with custom Instagram icon
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.pink)
                        }
                        
                        Button(action: {
                            if let url = URL(string: "https://www.twitter.com/YayDay") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "bubble.left") // Replace with custom Twitter icon
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.cyan)
                                .offset(y: -8)
                        
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(translationManager.translate("Settings"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
