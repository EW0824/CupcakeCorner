//
//  Order.swift
//  CupcakeCorner
//
//  Created by OAA on 26/12/2022.
//

import SwiftUI

class Order: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        // what we want to encode (save and send online)
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
        
        
    }
    
    
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    
    // @Published loses automatic codability conversion -> Swift doesn't know how to encode
    @Published var type = 0 // Only use indices to access if array is immutable
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || name.hasPrefix(" ") || name.hasPrefix(" ") ||
            streetAddress.isEmpty || streetAddress.hasPrefix(" ") || streetAddress.hasSuffix(" ") ||
            city.isEmpty || city.hasPrefix(" ") || city.hasSuffix(" ") ||
            zip.isEmpty || zip.hasPrefix(" ") || zip.hasSuffix(" ") {
            return false
        }
        
        return true
    }
    
    // We will learn a better way to store currency later
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        
        // complicated ones cost more
        cost += (Double(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
    
    // Empty initialiser, to be initialised at first (when there is nothing to decode)
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
}
