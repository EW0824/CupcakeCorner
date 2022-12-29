//
//  Day 49.swift
//  CupcakeCorner
//
//  Created by OAA on 25/12/2022.
//

import SwiftUI



// Solving the issue of @Published not being codeable
class User: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        case name
    }
    
    // @Published announces changes to all SwiftUI views
    @Published var name = "Paul Hudson"
    
    // required -> Anyone who subclasses 'USER' must override the initialiser with their custom code
    
    // from decoder: Decoder -> not any particular decoder - not JSON or XML - any decoder
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // .name -> avoids typos
        // String.self -> must be string
        name = try container.decode(String.self, forKey: .name)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}










struct Response: Codable {
    var results: [Result]
}

struct Result: Codable  {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct TaylorSwiftTracks: View {
    
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id:\.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                
                Text(item.collectionName)
            }
        }
        .task {
            await loadData() // Function might go to sleep
        }
    }
    
    // async -> Asynchronious functions! -> sleep for a bit waiting for network to load
    func loadData() async {
        // CREATE URL
        // guard, because we might support passed-in strings which might go wrong. Hard-coded URL cannot go wrong!
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        
        // FETCH URL
        do {
            // tuple: data and metadata. We don't need to metadata
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // DECODE URL
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
            
        } catch {
            // If no internet, etc
            print("Invalid data")
        }
    
        
    }
}


struct URLImage: View {
    
    var body: some View {
        // SwiftUI knows nothing about the image, so it cant give appropirate size
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 200, height: 200)
        
//        AsyncImage(url: URL(string: "https://hws.dev/img/bad.png")) {phase in
//            if let image = phase.image {
//                image
//                    .resizable()
//                    .scaledToFit()
//            } else if phase.error != nil {
//                Text("There was an error loading the image.")
//            } else {
//                ProgressView()
//            }
//        }
//        .frame(width: 200, height: 200)
    }
}


struct FormValidation: View {
    
    @State private var username = ""
    @State private var email = ""
    
    var body: some View {
        Form {
            
            Section {
                TextField("Username", text: $username)
                
                TextField("Email", text: $email)
                
            }
            
            Section {
                Button("Create account") {
                    print("Creating account")
                }
                .disabled(disableForm)
            }

        }
    }
    
    var disableForm: Bool {
        username.count < 5 || email.count < 5
    }
}





struct Day_49: View {
    
    var body: some View {
//        TaylorSwiftTracks()
        
//        URLImage()
        
        FormValidation()
    }
}




struct Day_49_Previews: PreviewProvider {
    static var previews: some View {
        Day_49()
    }
}
