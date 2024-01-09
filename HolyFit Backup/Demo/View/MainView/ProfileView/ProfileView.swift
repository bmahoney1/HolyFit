//
//  ProfileView.swift
//  Demo
//
//  Created by Brennan Mahoney on 5/27/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ProfileView: View {
    // Profile Data
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    // View Properties
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                if let myProfile{
                    ReusableProfileContent(user: myProfile)
                        .refreshable {
                            // Refresh User Data
                            self.myProfile = nil
                            await fetchUserData()
                        }
                }else {
                    ProgressView()
                }
            }
            .navigationTitle("Personal Health Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        // Two Actions
                        // Logout
                        // Delete Account
                        Button("Logout", action: logOutUser)
                        
                        Button("Delete Account", role: .destructive, action: deleteAccount)
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees:90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
        }
        .overlay{
            LoadingView(show: $isLoading)
        }
        .alert(errorMessage, isPresented: $showError){
            
        }
        .task {
            // This
            if myProfile != nil{return}
            // Initial Fetch
            await fetchUserData()
        }
    }
    
    // Fetching user data
    func fetchUserData()async{
        guard let userUID = Auth.auth().currentUser?.uid else{return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)
            else {return}
        await MainActor.run(body: {
            myProfile = user
        })
        
    }
    
    // Logging User Out
    func logOutUser(){
        try? Auth.auth().signOut()
        logStatus = false
    }
    
    // Deleting User Entire Account
    func deleteAccount(){
        isLoading = true
        Task{
            do{
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                // Delete image
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await reference.delete()
                // Deleting FireStore User Document
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                // Deleting Auth Account and setting log status to false
                try await Auth.auth().currentUser?.delete()
                logStatus = false
            } catch{
                await setError(error)
            }
            
        }
    }
    
    // Mark: Setting Error
    func setError(_ error: Error) async {
        // UI must be on main thread
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

