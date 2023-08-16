//
//  LoginView.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 04/03/2023.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @Binding var showSignInView: Bool
    
    @State private var showSignInAlert = false
    @State private var showSignUpAlert = false
    @State private var showAdminAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        
        NavigationStack{
            VStack{
                
                Spacer()
                
                VStack{
                    Text("POST OFFICE")
                        .foregroundColor(.red)
                        .fontWeight(.heavy)
                        .font(.system(size: 30))
                    Text("VIRTUAL QUEUEING APPLICATION")
                        .font(.system(size: 20))
                }
                
                Spacer()
                
                VStack{
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                }.padding(.bottom, 30)
                
                VStack{
                    
                    Group {
                        
                        HStack{
                            //Login Button
                            Button{
                                Task{
                                    do {
                                        try await viewModel.signIn()
                                        showSignInView = false
                                        return
                                    }catch {
                                        print(error)
                                    }
                                    
                                    do{
                                        showSignInAlert = true
                                    }
                                }
                            }label: {
                                Text("Sign In")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                
                            }.alert(isPresented: $showSignInAlert) {
                                Alert(
                                    title: Text("Could not sign you in"),
                                    message: Text("Email or Password is incorrect")
                                )
                            }
                            
                            //REGISTER BUTTON
                            Button{
                                Task{
                                    do {
                                        try await viewModel.signUp()
                                        showSignInView = false
                                        return
                                    }catch {
                                        print(error)
                                    }
                                    
                                    do{
                                        showSignUpAlert = true
                                    }
                                }
                            }label: {
                                Text("Register")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                
                            }.alert(isPresented: $showSignUpAlert) {
                                Alert(
                                    title: Text("Could not sign you in"),
                                    message: Text("Account Already Exists")
                                )
                            }
                        }
                    }
                    
                    
                }
                
                Spacer()
                
            }.padding()
                .navigationTitle("Sign In With Email")
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showSignInView: .constant(false))
    }
}
