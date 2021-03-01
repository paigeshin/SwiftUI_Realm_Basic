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
