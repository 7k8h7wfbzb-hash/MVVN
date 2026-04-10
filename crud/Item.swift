//
//  Item.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
