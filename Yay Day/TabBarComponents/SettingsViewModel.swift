//
//  SettingsViewModel.swift
//  Yay Day
//
//  Created by Anders Staal on 25/09/2024.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
        }
    }

    init() {
        
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "da"
    }
}

class TranslationManager: ObservableObject {
    static let shared = TranslationManager()

    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
        }
    }
    
    func translate(_ key: String) -> String {
        return translations[key]?[selectedLanguage] ?? key
    }
    
    func updateLanguage(_ language: String) {
           selectedLanguage = language
           UserDefaults.standard.set(language, forKey: "selectedLanguage")
       }
    
    

    init() {
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "da"
    }

    // Translation dictionary
    private let translations: [String: [String: String]] = [
        "title": [
            "en": "Title",
            "da": "Titel"
        ],
        
        "Home": [
            "en": "Home",
            "da": "Forside"
        ],
        
        "Filtrering": [
            "en": "Filter",
            "da": "Filtrér"
        ],
        
        "Profil": [
            "en": "Profile",
            "da": "Profil"
        ],
        
        "Favoritter": [
            "en": "Favourites",
            "da": "Favoritter"
        ],
        
        "Ingen_Favoritter": [
            "en": "No favourites yet. Click the heart in the top right corner of an event, to save it in Favourites",
            "da": "Ingen favoritter endnu. Tryk på hjertet oppe i højre hjørne på et event, for at gemme det i Favoritter"
        ],
        
        "Ingen_Favoritter1": [
            "en": "No Bookings yet. Click the Book Button at the bottom of an event page to book it, and get your overview at the bookings page",
            "da": "Ingen bookings endnu. Tryk på Book Button nederst på et event, for at booke det, og se et overblik i Bookings"
        ],
        
        "Remove Booking": [
            "en": "Remove Booking",
            "da": "Fjern Booking"
        ],
        
        "Book now": [
            "en": "Book nu",
            "da": "Book now"
        ],
        
        "See_more": [
            "en": "See more",
            "da": "Se mere"
        ],
        
        "welcome_message": [
            "en": "Welcome to the Event",
            "da": "Velkommen til Begivenheden"
        ],
        "dark_mode": [
            "en": "Dark Mode",
            "da": "Mørk tilstand"
        ],
        "language": [
            "en": "Language",
            "da": "Sprog"
        ],
        
        "EventsNearYou_message": [
            "en": "See events near you",
            "da": "Se oplevelser tæt på dig"
        ],
        
        "New_on_yay": [
            "en": "New on yay",
            "da": "Nye på yay"
        ],
        
        "Lidt_af_hvert": [
            "en": "A bit of everything",
            "da": "Lidt af hvert"
        ],
        
        "Kommunen_tilbyder": [
            "en": "Municipality offers",
            "da": "Kommunen tilbyder"
        ],
        
        "Denne_uge": [
            "en": "This week",
            "da": "Denne uge"
        ],
        
        "Start_date": [
            "en": "Start Date",
            "da": "Start Dato"
        ],
        
        "End_date": [
            "en": "End date",
            "da": "Slut dato"
        ],
        
        "Start_time": [
            "en": "Start time?",
            "da": "Start tid?"
        ],
        
        "Max_distance": [
            "en": "Max distance",
            "da": "Max distance"
        ],
        
        "Kategorier": [
            "en": "Categories",
            "da": "Kategorier"
        ],
        
        "Min_price": [
            "en": "Min price:",
            "da": "Min pris:"
        ],
        
        "Max_price": [
            "en": "Max price:",
            "da": "Max pris:"
        ],
        
        "Apply_filter": [
            "en": "Apply filter",
            "da": "Benyt filter"
        ],
        
        "English": [
            "en": "english",
            "da": "engelsk"
        ],
        
        "Danish": [
            "en": "danish",
            "da": "dansk"
        ],
        
        "Settings": [
            "en": "Settings",
            "da": "Indstillinger"
        ],
        
        "See_route": [
            "en": "See route",
            "da": "Se rute"
        ],
        
        "Gem": [
                   "en": "Save",
                   "da": "Gem"
               ],
               "Gemt": [
                   "en": "Saved",
                   "da": "Gemt"
               ],
        
        "Praktisk_info": [
            "en": "Practical information",
            "da": "Praktisk information"
        ],
        
        "Book_Now": [
            "en": "Book now / Read More",
            "da": "Book nu / Læs mere"
        ],
        
        "Kultur": [
                "en": "Culture",
                "da": "Kultur"
            ],
            "Sport": [
                "en": "Sport",
                "da": "Sport"
            ],
            "Mad & Drikke": [
                "en": "Food & drink",
                "da": "Mad & drikke"
            ],
            "Musik": [
                "en": "Music",
                "da": "Musik"
            ],
            "Kommune": [
                "en": "Municipality",
                "da": "Kommune"
            ],
            "Date": [
                "en": "Date",
                "da": "Date"
            ],
            "Solo": [
                "en": "Solo",
                "da": "Solo"
            ],
            "Outdoor": [
                "en": "Outdoor",
                "da": "Outdoor"
            ],
            "Fest": [
                "en": "Party",
                "da": "Fest"
            ],
            "Hygge": [
                "en": "Cozy",
                "da": "Hygge"
            ],
            "Børn & unge": [
                "en": "Children & Youth",
                "da": "Børn & unge"
            ],
            "Natur": [
                "en": "Nature",
                "da": "Natur"
            ],
            "Foredrag": [
                "en": "Lecture",
                "da": "Foredrag"
            ],
            "Teater": [
                "en": "Theatre",
                "da": "Teater"
            ],
            "Comedy": [
                "en": "Comedy",
                "da": "Comedy"
            ],
        "CopyLink": [
            "en": "Copy Event Link",
            "da": "Kopier Event Link"
        ],
        
        "WhereGoing": [
            "en": "Trip goes to?",
            "da": "Turen går til?"
        ],
        
        "FreeEvents": [
            "en": "Free events",
            "da": "Gratis events"
        ],
        
        "No_match": [
            "en": "You can try new filters to get a result, we hope you find your perfect Yay Day",
            "da": "Du kan ændre i filtrene for et nyt resultat, vi håber du finder din perfekte Yay Day"
        ],
        
        
        "EventsIdag": [
            "en": "Events today",
            "da": "Begivenheder idag"
        ],
        
        "Enable Notifications": [
            "en": "Enable Notifications",
            "da": "Tænd Notifikationer"
        ],
        
        
        "Notifications": [
            "en": "Notifications",
            "da": "Notifikationer"
        ],
        
        
        "Send event til en ven?":  [
            "en": "Send event to a friend?",
            "da": "Send event til en ven?"
        ],
        
        "SearchEvents": [
            "en": "Search events",
            "da": "Søg events"
        ],
        
        "SearchEventsOrCategory": [
            "en": "Search eventplaces or categories",
            "da": "Søg eventsteder og kategorier"
        ],
        
        
        "GetAnotherEvent": [
            "en": "Get another event",
            "da": "Prøv et nyt event"
        ],
        
        "NoEventMatch": [
            "en": "No match, try again",
            "da": "Intet match, prøv igen"
        ],
    ]

   

}
