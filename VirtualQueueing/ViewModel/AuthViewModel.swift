//
//  AuthViewModel.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 30/06/2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthViewModel: ObservableObject {
    
    //used in LoginView
    @Published var email = String()
    @Published var password = String()
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published private(set) var user: DBUser? = nil
    
    //used in ProfileUpdateView
    @Published var name: String = ""
    @Published var phone: String = ""
    
    func loadAuthProviders(){
        if let providers = try? AuthenticationManager.shared.getProviders(){
            authProviders = providers
        }
    }
    
    func loadCurrentUser() async throws{
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await userManager.shared.getUser(userID: authDataResult.uid)
    }
    
    enum SignInError: Error {
        case emptyFields(String)
        case SignInFailed(String)
    }
    
    func signUp() async throws{
        guard !email.isEmpty, !password.isEmpty else{
            print("No email or password is found!")
            throw SignInError.emptyFields("Email or Password cannot be emptied")
        }
        
        do{
            let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
            let user = DBUser(userID: authDataResult.uid, email: authDataResult.email, name: authDataResult.name, phone: authDataResult.phone, photoURL: authDataResult.photoURL, dateCreated: Date())
            try await userManager.shared.createNewUser(user: user)
        } catch {
            throw SignInError.SignInFailed(error.localizedDescription)
        }
        
    }
    
    func signIn() async throws{
        guard !email.isEmpty, !password.isEmpty else{
            print("No email or password is found!")
            throw SignInError.emptyFields("Email or Password cannot be emptied")
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
    func signInGoogle() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        
        try await userManager.shared.createNewUser(user: user)
    }
    
    //update only name and phone of the user
    func updateUser() async throws{
        guard let user else {
            return
        }
        let currentName = name
        let currentPhone = phone
        let updatedUser = DBUser(userID: user.userID,email: user.email, name: currentName, phone: currentPhone, photoURL: user.photoURL, dateCreated: user.dateCreated )
        Task{
            try await userManager.shared.updateUser(user: updatedUser)
            self.user = try await userManager.shared.getUser(userID: user.userID)
        }
    }
    
    func updateName(newName: String) {
        name = newName
    }
    
    func updatePhone(newPhone: String) {
        phone = newPhone
    }
    
    func deleteAccount() async throws{
        try await AuthenticationManager.shared.delete()
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
}
