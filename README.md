# Realm Model

```swift
//
//  Card.swift
//  RealmBasic
//
//  Created by paige shin on 2021/03/01.
//

import SwiftUI
import RealmSwift

// Creating Realm Object ...

class Card: Object, Identifiable {
    
    @objc dynamic var id: Date = Date()
    @objc dynamic var title = ""
    @objc dynamic var detail = ""
    
}
```

# ViewModel

```swift
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
```

# Views

```swift
//
//  Home.swift
//  RealmBasic
//
//  Created by paige shin on 2021/03/01.
//

import SwiftUI

struct Home: View {
    
    @StateObject var modelData = DBViewModel()
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack(spacing: 15) {
                    ForEach(modelData.cards) { card in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(card.title)
                            Text(card.detail)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(10)
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .contextMenu(ContextMenu(menuItems: { // Long Click Listener
                            Button(action: {
                                modelData.deleteData(object: card)
                            }, label: {
                                Text("Delete Item")
                            })
                            Button(action: {
                                modelData.updateObject = card
                                modelData.openNewPage.toggle()
                            }, label: {
                                Text("Update Item")
                            })
                        }))
                    }
                }
                .padding()

                
            }
            .navigationTitle("Realm DB")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        modelData.openNewPage.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    })
                    
                }
            })
            .sheet(isPresented: $modelData.openNewPage, content: {
                AddPageView()
                    .environmentObject(modelData)
            })
            
        }
        
    }
}
```

```swift
//
//  AddPageView.swift
//  RealmBasic
//
//  Created by paige shin on 2021/03/01.
//

import SwiftUI

struct AddPageView: View {
    
    @EnvironmentObject var modelData: DBViewModel
    @Environment(\.presentationMode) var presentatationMode
    
    var body: some View {
        
        // To Get Form Like View...
        NavigationView {
            
            List {
                Section(header: Text("Title")) {
                    TextField("", text: $modelData.title)
                }
                Section(header: Text("Detail")) {
                    TextField("", text: $modelData.detail)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(modelData.updateObject == nil ? "Add Data" : "Update")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        modelData.addData(presentation: presentatationMode)
                    }, label: {
                        Text("Done")
                    })
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentatationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
            })
            
        }
        .onAppear(perform: modelData.setUpInitialData)
        .onDisappear(perform: modelData.deInitData)

        
    }
}
```