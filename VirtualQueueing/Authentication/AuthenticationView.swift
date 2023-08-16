//
//  AuthenticationView.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 30/03/2023.
//

import SwiftUI

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        NavigationStack{
            VStack(){
                
                Group {
                    Text("Welcome,")
                        .alignmentGuide(HorizontalAlignment.center) { _ in -20 }
                        .font(.system(size: 35))
                        .bold()
                        .padding(.bottom, 10)
                    
                    VStack{
                        Text("POST OFFICE")
                            .foregroundColor(.red)
                            .fontWeight(.heavy)
                            .font(.system(size: 30))
                        Text("VIRTUAL QUEUEING APPLICATION")
                            .font(.system(size: 20))
                    }
                }
                
                
                Spacer()
                    .frame(height: 120)
                
                Text("Please log in to continue")
                    .foregroundColor(.gray)
                    .monospaced()
                
                Spacer()
                    .frame(height: 90)
                
                Group {
                    NavigationLink{
                        LoginView(showSignInView: $showSignInView)
                    } label: {
                        Text("Sign In with Email")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Text("OR")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 15))
                    
                    Button {
                        Task{
                            do{
                                try await viewModel.signInGoogle()
                                showSignInView = false
                            } catch{
                                print(error)
                            }
                        }
                    } label: {
                        Text("Sign In with Google")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                
                
                
            }
            .padding(.horizontal)
        }
        
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
