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


