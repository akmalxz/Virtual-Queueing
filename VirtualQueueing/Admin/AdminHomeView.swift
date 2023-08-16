//
//  AdminHomeView.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 01/05/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class AdminHomeViewModel: ObservableObject{
    
    func nextQueue(category:String){
        queueManager.shared.deleteQueue(category: category)
    }
    
    func holdQueue(category:String) async throws{
        try await queueManager.shared.updateQMissed(category: category)
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
}

struct AdminHomeView: View {
    
    @StateObject private var viewModel = AdminHomeViewModel()
    
    @State private var showSignOutAlert = false
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                
                Image("backgroundDesign7")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack{
                    
                    /* roadtax&license */
                    ZStack{
                        
                        Rectangle()
                            .fill(.white)
                            .opacity(0.9)
                            .frame(width: 370,height: 150)
                            .border(.black, width: 3)
                        
                        HStack{
                            
                            Spacer()
                            
                            VStack{
                                Text("Renew Roadtax")
                                Text("and")
                                Text("Driving Licenses")
                                
                            }
                            .fontWeight(.heavy)
                            .font(.system(size: 17))
                            .padding(.horizontal)
                            
                            VStack{
                                
                                Button{
                                    Task{
                                        do {
                                            viewModel.nextQueue(category: "paybill")
                                        }
                                    }
                                }label: {
                                    Text("NEXT TOKEN")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(height: 45)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                    
                                }
                                
                                Button{
                                    Task{
                                        do {
                                            try await viewModel.holdQueue(category: "paybill")
                                        }
                                    }
                                }label: {
                                    Text("HOLD TOKEN")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(height: 45)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                    
                                }
                                
                                
                            }.padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                    
                    /* bill */
                    ZStack{
                        
                        Rectangle()
                            .fill(.white)
                            .opacity(0.9)
                            .frame(width: 370,height: 150)
                            .border(.black, width: 3)
                        
                        HStack{
                            
                            Spacer()
                            
                            Text("Pay Bill")
                                .fontWeight(.heavy)
                                .font(.system(size: 17))
                                .padding(.horizontal)
                            
                            Spacer().frame(width: 90)
                            
                            
                            VStack{
                                
                                Button{
                                    Task{
                                        do {
                                            viewModel.nextQueue(category: "paybill")
                                        }
                                    }
                                }label: {
                                    Text("NEXT TOKEN")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(height: 45)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                    
                                }
                                
                                Button{
                                    Task{
                                        do {
                                            try await viewModel.holdQueue(category: "paybill")
                                        }
                                    }
                                }label: {
                                    Text("HOLD TOKEN")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(height: 45)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                    
                                }

                                
                                
                            }.padding(.horizontal)
                            
                            Spacer()
                            
                        }
                        
                    }
                    
                    /* parcel */
                    ZStack{
                        
                        Rectangle()
                            .fill(.white)
                            .opacity(0.9)
                            .frame(width: 370,height: 150)
                            .border(.black, width: 3)
                        
                        HStack{
                            
                            Spacer()
                            
                            VStack{
                                
                                Text("Send Parcel")
                                Text("and Pickup Parcel")
                                
                            }.fontWeight(.heavy)
                                .font(.system(size: 17))
                                .padding(.horizontal)
                            
                            VStack{
                                
                                Button{
                                    Task{
                                        do {
                                            viewModel.nextQueue(category: "paybill")
                                        }
                                    }
                                }label: {
                                    Text("NEXT TOKEN")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(height: 45)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                    
                                }
                                
                                Button{
                                    Task{
                                        do {
                                            try await viewModel.holdQueue(category: "paybill")
                                        }
                                    }
                                }label: {
                                    Text("HOLD TOKEN")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(height: 45)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                    
                                }
                                
                                
                            }.padding(.horizontal)
                            
                            Spacer()
                            
                        }
                        
                    }
                    
                    Button {
                        showSignOutAlert = true
                    } label: {
                        Text("LOGOUT")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.all)
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
                    
                }
                
            }.navigationTitle("TYPE OF SERVICES")
            
        }.ignoresSafeArea()
        
    }
}

struct AdminHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AdminHomeView(showSignInView: .constant(false))
    }
}
