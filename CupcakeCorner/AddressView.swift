//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by OAA on 26/12/2022.
//

import SwiftUI

struct AddressView: View {
    
    // SAVES the order detail (e.g. address) and never delete it
    @ObservedObject var order: Order
    
    var body: some View {
        

        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip code", text: $order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
                .disabled(order.hasValidAddress == false)
                
            }
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        // It will be in a navView from the previous screen
        NavigationView {
            AddressView(order: Order())
        }
    }
}
