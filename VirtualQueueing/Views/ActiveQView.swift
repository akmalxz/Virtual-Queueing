//
//  ActiveQView.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 06/03/2023.
//

import SwiftUI

struct ActiveQView: View {
    
    @StateObject private var viewModel = ServiceViewModel()
    @State private var showLeaveQAlert: Bool = false
    @State private var reminderAlert: Bool = true
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                
                ScrollView{
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Text("CURRENT SERVING NO.")
                        .fontWeight(.heavy)
                    
                    //current number
                    ZStack{
                        
                        Rectangle()
                            .fill(.green.gradient)
                            .frame(width:350, height: 200)
                            .cornerRadius(20)
                        
                        VStack{
                            
                            ForEach(viewModel.queue) { queue in
                                if queue.status == "served"{
                                    Text(queue.token ?? "")
                                        .fontWeight(.heavy)
                                        .font(.system(size: 34))
                                        .padding(.bottom)
                                }
                            }
                            
                            Text("POST OFFICE")
                                .padding(.all)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 5)
                                )
                        }
                    }
                    
                    Spacer()
                    
                    //body
                    VStack{
                        
                        HStack{
                            
                            Spacer()
                            
                            //estimated time, customer number and leave button view
                            VStack{
                                
                                Text("ESTIMATED WAITING TIME")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                
                                ZStack{
                                    Rectangle()
                                        .fill(.white.gradient)
                                        .opacity(0.6)
                                        .frame(width: 170, height: 100)
                                        .border(.black, width: 2)
                                        
                                    // MARK: ADD the estimation time to this text
                                    ForEach(viewModel.userQueue){ queue in
                                        
                                        if queue.status == "hold" {
                                            VStack{
                                                Text("ON-HOLD")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                                Text("Patiently wait in the waiting area")
                                                    .font(.system(size: 9))
                                                    .fontWeight(.semibold)
                                                    .padding(.top, 10)
                                            }
                                            
                                        } else {
                                            Text(String(queue.estWaitTime ?? 0) + " minutes")
                                                .font(.system(size: 19))
                                                .fontWeight(.semibold)
                                        }
                                        
                                    }
                                    
                                }
                                
                                Text("Your Number")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                
                                ZStack{
                                    Rectangle()
                                        .fill(.white.gradient)
                                        .opacity(0.6)
                                        .frame(width: 170, height: 100)
                                        .border(.black, width: 2)
                                    
                                    // MARK: ADD customer's token number into this text
                                    ForEach(viewModel.userQueue){ queue in
                                        Text(queue.token ?? "")
                                            .font(.system(size: 19))
                                            .fontWeight(.semibold)
                                        
                                    }
                                    
                                }
                                
                                //LEAVE QUEUE BUTTON
                                Button {
                                    showLeaveQAlert = true
                                } label: {
                                    Text("CANCEL QUEUE")
                                        .foregroundColor(.white)
                                        .fontWeight(.heavy)
                                }
                                .alert("Leave Queue", isPresented: $showLeaveQAlert) {
                                    Button("Cancel", role: .cancel) {
                                        // nothing needed here
                                    }
                                    Button("Yes", role: .destructive) {
                                        Task{
                                            do{
                                                try? await viewModel.leaveQ()
                                            }
                                        }
                                    }
                                } message: {
                                    Text("Are you sure?")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Color.red)
                                
                            }
                            
                            Spacer()
                            
                            //waiting list view
                            VStack{
                                
                                Text("WAITING LIST")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                
                                ZStack{
                                    
                                    Rectangle()
                                        .fill(.yellow.gradient)
                                        .opacity(0.6)
                                        .frame(width: 100, height: 270)
                                        .cornerRadius(10)
                                    
                                    VStack{
                                        
                                        //viewing token number with the status of waiting
                                        ForEach(viewModel.queue) { queue in
                                            if queue.status == "waiting"{
                                                Text(queue.token ?? "")
                                            }
                                        }
                                    }.fontWeight(.heavy)
                                    
                                }
                            }
                            
                            Spacer()
                            
                        }
                        
                    }
                    
                    Spacer()
                    
                }.refreshable {
                    try? await viewModel.getUserQueue()
                }
                
            }.navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack(spacing: 4) {
                            Text("ACTIVE QUEUE")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .padding(.top)
                        }
                    }
                }
                .task {
                    try? await viewModel.getUserQueue()
                }
                .alert(isPresented: $reminderAlert) {
                    Alert(title: Text("Reminder"),
                          message: Text("If you missed your token, patiently wait in the waiting area, your token will be call later."),
                          dismissButton: .default(Text("Got it!")))
                }
        }
    }
}

struct ActiveQView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveQView(showSignInView: .constant(false))
    }
}
