//
//  ProfileView.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 05/03/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @Binding var showSignInView: Bool
    
    @State var name: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var presentEditProfileSheet = false
    @State private var showCloseAccAlert = false
    @State private var showSignOutAlert = false
    
    private func editButton(action: @escaping () -> Void) -> some View{
        Button(action: {action() }){
            Text("Edit")
        }
    }
    
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                
                Image("backgroundDesign4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: true) {
                    VStack{
                        
                        VStack{
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .padding(.all)
                        }
                        
                        Text("PROFILE INFORMATION")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.leading)
                        
                        //profile information
                        VStack{
                            
                            if let user = viewModel.user{
                                
                                HStack{
                                    Text("Name: ")
                                    Spacer()
                                    Text(user.name ?? "")
                                        .padding(.vertical)
                                        .frame(maxWidth: 300)
                                        .background(Color.gray.opacity(0.4))
                                        .cornerRadius(10)
                                }
                                
                                HStack{
                                    Text("Email: ")
                                    Spacer()
                                    Text(user.email ?? "")
                                        .padding(.vertical)
                                        .frame(maxWidth: 300)
                                        .background(Color.gray.opacity(0.4))
                                        .cornerRadius(10)
                                }
                                
                                HStack{
                                    Text("Phone: ")
                                    Spacer()
                                    Text(user.phone ?? "")
                                        .padding(.vertical)
                                        .frame(maxWidth: 300)
                                        .background(Color.gray.opacity(0.4))
                                        .cornerRadius(10)
                                }
                            }
                            
                        }
                        .task {
                            try? await viewModel.loadCurrentUser()
                        }
                        .padding(.all)
                        .font(.system(size: 12))
                        
                        Button {
                            self.presentEditProfileSheet.toggle()
                        } label: {
                            Text("EDIT PROFILE")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }.padding()
                        
                        
                        Divider()
                            .frame(height: 2)
                            .overlay(.black)
                            .cornerRadius(15)
                            .padding(.horizontal)
                        
                        //delete and logout button
                        VStack{
                            
                            Button {
                                showSignOutAlert = true
                            } label: {
                                Text("LOGOUT")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                            .alert("Logout", isPresented: $showSignOutAlert) {
                                Button("Cancel", role: .cancel) {
                                    // nothing needed here
                                }
                                Button("Yes", role: .destructive) {
                                    Task{
                                        do{
                                            try viewModel.signOut()
                                            showSignInView = true
                                        }catch{
                                            print(error)
                                        }
                                    }
                                }
                            } message: {
                                Text("Are you sure?")
                            }
                            
                            Button {
                                showCloseAccAlert = true
                            } label: {
                                Text("DELETE ACCOUNT")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                            .alert("Delete Account", isPresented: $showCloseAccAlert) {
                                Button("Cancel", role: .cancel) {
                                    // nothing needed here
                                }
                                Button("Yes", role: .destructive) {
                                    Task{
                                        do{
                                            try await viewModel.deleteAccount()
                                            showSignInView = true
                                        }catch{
                                            print(error)
                                        }
                                    }
                                }
                            } message: {
                                Text("Are you sure?")
                            }
                            
                            
                        }.padding(.all)
                        
                    }.padding(.bottom, 60)
                }
                .refreshable {
                    Task{
                        do{
                            try? await viewModel.loadCurrentUser()
                        }
                    }
                }
            }.navigationTitle("Settings")
                .sheet(isPresented: self.$presentEditProfileSheet) {
                    
                    ProfileUpdateView(showSignInView: $showSignInView, presentEditProfileSheet: $presentEditProfileSheet)
                }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showSignInView: .constant(false))
    }
}
