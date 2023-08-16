//
//  RoadTaxQView.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 05/03/2023.
//

import SwiftUI

struct RoadTaxQView: View {
    
    @StateObject private var viewModel = ServiceViewModel()
    @Binding var showSignInView: Bool
    
    @State var showJoinQAlert = false
    @State var showFailJoinQAlert = false
    
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                
                Image("backgroundQDesign4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                //body
                VStack{
                    
                    Spacer()
                    
                    Text("CURRENT QUEUE NO.")
                        .fontWeight(.heavy)
                    
                    //current number
                    ZStack{
                        
                        Rectangle()
                            .fill(.green.gradient)
                            .frame(width:350, height: 200)
                            .cornerRadius(20)
                        
                        //View the token number that is being served
                        VStack{
                            
                            ForEach(viewModel.queue) { queue in
                                if queue.status == "served", queue.category == "roadtax"{
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
                    
                    VStack{
                        
                        HStack{
                            
                            Spacer()
                            
                            VStack{
                                
                                //button to join the queue
                                Button{
                                    Task{
                                        do{
                                            try await viewModel.joinQueue(category: "roadtax")
                                        } catch {
                                            showFailJoinQAlert = true
                                        }
                                        
                                        if showFailJoinQAlert == true {
                                            showJoinQAlert = false
                                        } else {
                                            showJoinQAlert = true
                                        }
                                    }
                                }label: {
                                    Text("JOIN QUEUE")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(height: 55)
                                        .frame(maxWidth: 200)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .alert(isPresented: $showFailJoinQAlert){
                                    Alert(title: Text("Unable to join Queue"),
                                          message: Text("It appears that your account already in a queue, please leave your current queue before joining other queue.")
                                    )
                                }
                                .alert("Queue Joined!", isPresented: $showJoinQAlert) {
                                    NavigationLink {
                                        ActiveQView(showSignInView: $showSignInView)
                                    } label: {
                                        Text("Continue")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(height: 55)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                                }
                                
                            }
                            
                            Spacer()
                            
                            //waiting list
                            VStack{
                                
                                Text("WAITING LIST")
                                    .fontWeight(.heavy)
                                
                                ZStack{
                                    
                                    Rectangle()
                                        .fill(.yellow.gradient)
                                        .opacity(0.6)
                                        .frame(width: 100, height: 250)
                                        .cornerRadius(10)
                                    
                                    VStack{
                                        
                                        //viewing token number with the status of waiting
                                        ForEach(viewModel.queue) { queue in
                                            if queue.status == "waiting", queue.category == "roadtax"{
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
                    
                    Spacer()
                    
                }
                
            }
        }.navigationTitle("RENEW ROADTAX AND DRIVING LICENSE")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                try? await viewModel.getSortedQ(category: "roadtax")
            }
        
    }
}



struct RoadTaxQView_Previews: PreviewProvider {
    static var previews: some View {
        RoadTaxQView(showSignInView: .constant(false))
    }
}
