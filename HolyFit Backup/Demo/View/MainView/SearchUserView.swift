//
//  SearchUserView.swift
//  Demo
//
//  Created by Brennan Mahoney on 6/2/23.
//

import SwiftUI
import FirebaseFirestore

struct SearchUserView: View {
    // View properties
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        List{
            ForEach(fetchedUsers){user in
                NavigationLink {
                    ReusableProfileContent(user: user)
                }label: {
                    Text(user.username)
                        .font(.callout)
                        .hAlign(.leading)
                }
                
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search User")
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            // Fetch user from firebase
            Task{await searchUsers()}
        })
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty{
                fetchedUsers = []
            }
            
        })
        
    }
    
    func searchUsers()async{
        do{
            
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("username", isGreaterThanOrEqualTo: searchText)
                .whereField("username", isLessThanOrEqualTo: "\(searchText)\u{f8ff}" )
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
                
            }
            // UI must be updated on main Thread
            await MainActor.run(body: {
                fetchedUsers = users
            })
        }catch{
            print(error.localizedDescription)
        }
    }
}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}
