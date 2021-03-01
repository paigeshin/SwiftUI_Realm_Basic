//
//  DBViewModel.swift
//  RealmBasic
//
//  Created by paige shin on 2021/03/01.
//

import SwiftUI
import RealmSwift

class DBViewModel: ObservableObject {
    
    // Data....
    @Published var title = ""
    @Published var detail = ""
    
    @Published var openNewPage = false
    
    // Fetched Data...
    @Published var cards: [Card] = []
    
    // Data Updating....
    @Published var updateObject: Card?
    
    init() {
        fetchData()
    }
    
    // Fetching Data...
    func fetchData() {
        
        guard let dbRef = try? Realm() else { return }
        
        let results = dbRef.objects(Card.self)
        
        // Displaying results...
        
        self.cards = results.compactMap({ (card) -> Card? in
            return card
        })
        
    }
    
    // Adding New Data... Updating Data...
    func addData(presentation: Binding<PresentationMode>) {
        
        let card = Card()
        card.title = title
        card.detail = detail
        
        // Getting Reference....
        
        guard let dbRef = try? Realm() else { return }
        
        // Writing Data...
        try? dbRef.write {
            
            
            // Checking and Wiriting Data....
            
            guard let availableObject = updateObject else {
                dbRef.add(card)
                // Updating UI
                return
            }
            
            availableObject.title = title
            availableObject.detail = detail
            
        }
        
        // Updating UI
        fetchData()
        
        // Closing View
        presentation.wrappedValue.dismiss()
        
    }
    
    // Deleting Data
    func deleteData(object: Card) {
        
        guard let dbRef = try? Realm() else { return }
        
        try? dbRef.write {
            dbRef.delete(object)
            fetchData()
        }
        
    }
    
    // Setting And Clearing Data....
    func setUpInitialData() {
        
        // Updating...
        
        guard let updateData = updateObject else { return }
        
        // Checking if it's updating object and assigning value..
        
        title = updateData.title
        detail = updateData.detail
        
        let card = Card()
        card.title = title
        card.detail = detail
        

    }
    
    func deInitData() {
        
        title = ""
        detail = ""
        
    }
    
}
