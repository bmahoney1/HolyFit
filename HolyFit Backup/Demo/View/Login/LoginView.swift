//
//  LoginView.swift
//  Demo
//
//  Created by Brennan Mahoney on 5/18/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    // MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    // View properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    // User default
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        VStack(spacing: 10){
            //Text("Lets sign you in")
            //    .font(.largeTitle.bold())
            //    .hAlign(.center)
            //    .vAlign(.bottom)
            
            //Text("Welcome")
            //    .font(.title3)
            //    .hAlign(.center)
            //    .vAlign(.bottom)
            
            Text("Welcome to HolyFit")
                .font(.largeTitle.bold())
            
            VStack(spacing: 12){
                
        
                
                Image("frontlogo")
                    .resizable()
                    .padding(.top,325)
                
                
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    //.padding(.top,25)
                
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    //.vAlign(.bottom)
                
                Button("Reset password?", action: resetPassword)
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.center)
                    //.vAlign(.bottom)
                
                Button(action: loginUser){
                    // Mark: Login Button
                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top,10)
            }
            .vAlign(.bottom)
            .padding(.vertical, -300)
            
            // Register Buttom
            
            HStack{
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button("Register Now"){
                    createAccount.toggle()
                }
                
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
            
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        // Register View VIA Sheets
        .fullScreenCover(isPresented: $createAccount){
            RegisterView()
        }
        // Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    func loginUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                try await Auth.auth().signIn(withEmail:emailID, password: password)
                print("User Found")
                try await fetchUser()
            }catch{
               await setError(error)
            }
        }
    }
    
    // If user if found then fetching user data from firestore
    func fetchUser() async throws{
        guard let userID = Auth.auth().currentUser?.uid else{return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        // UI updatinf must be run on main thread
        await MainActor.run(body: {
            //  Setting userdefeaults data abd changinf apps auth status
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
            
        })
    }
    
    func resetPassword(){
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            }catch{
               await setError(error)
            }
        }
        
    }
    
    // Displaying Errors Via Alert
    func setError(_ error: Error)async{
        // UI Must be updated on main thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// Mark: View Extensions for UI Building


