//
//  ProfileUpdateView.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 08/04/2023.
//

import SwiftUI

enum Mode{
    case new
    case edit
}

struct ProfileUpdateView: View {
    
    @ObservedObject var viewModel = AuthViewModel()
    @Binding var showSignInView: Bool
    
    @Binding var presentEditProfileSheet: Bool
    var mode: Mode = .new
    
    var body: some View {
        NavigationView {
            
            if let user = viewModel.user{
                
                VStack{
                    
                    HStack{
                        Text("USER ID:")
                        Spacer()
                        Text(user.userID)
                            .padding()
                            .frame(maxWidth: 300)
                            .background(Color.gray.opacity(0.4))
                            .cornerRadius(10)
                    }
                    
                    HStack{
                        Text("EMAIL:")
                        Spacer()
                        Text(user.email ?? "")
                            .padding()
                            .frame(maxWidth: 300)
                            .background(Color.gray.opacity(0.4))
                            .cornerRadius(10)
                    }
                    
                    if user.name == ""{
                        HStack{
                            Text("NAME: ")
                            Spacer()
                            TextField("Name...", text: $viewModel.name)
                                .padding()
                                .frame(maxWidth: 300)
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(10)
                        }
                        
                    } else {
                        
                        HStack{
                            Text("NAME: ")
                            Spacer()
                            TextField("Name...", text: $viewModel.name)
                                .padding()
                                .frame(maxWidth: 300)
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(10)
                            
                        }.task {
                            viewModel.updateName(newName: user.name ?? "")
                        }
                        
                    }
                    
                    if user.phone == "" {
                        HStack{
                            Text("PHONE:")
                            Spacer()
                            TextField("Phone...", text: $viewModel.phone)
                                .padding()
                                .frame(maxWidth: 300)
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(10)
                        }
                    } else {
                        
                        HStack{
                            Text("PHONE:")
                            Spacer()
                            TextField("Phone...", text: $viewModel.phone)
                                .padding()
                                .frame(maxWidth: 300)
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(10)
                        }.task {
                            viewModel.updatePhone(newPhone: user.phone ?? "")
                        }
                    }
                    
                    
                    
                    Button {
                        Task{
                            do{
                                try await viewModel.updateUser()
                                presentEditProfileSheet = false
                            } catch{
                                print(error)
                            }
                        }
                    } label: {
                        Text("SAVE INFORMATION")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                }
                .padding(.all)
                .font(.system(size: 12))
                .navigationTitle("Update Information")
                
            }
            
        }.task {
            try? await viewModel.loadCurrentUser()
        }
    }
}

struct ProfileUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUpdateView(showSignInView: .constant(false), presentEditProfileSheet: .constant(false))
    }
}
