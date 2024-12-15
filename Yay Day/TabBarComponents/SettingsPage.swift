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
            Color(red: 0.96, green: 0.94, blue: 0.89)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Form {
                    Section(header: Text(translationManager.translate("language"))
                                                .foregroundColor(.black)){
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
                        .background(Color.orange.opacity(0.9))
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                        
                    }
                                      
                    
                    
                    Section(header: Text(translationManager.translate("Notifications"))
                                                .foregroundColor(.black)){
                        Toggle(translationManager.translate("Enable Notifications"), isOn: $notificationsEnabled)
                    }
                    

                }
                .padding(.top, 30)
                .background(Color(red: 0.99, green: 0.97, blue: 0.88))
                
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle(translationManager.translate("Settings"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
