//
//  Dashboard.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 22/05/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class DashBoardViewModel: ObservableObject {
    
    @Published private(set) var queues: [DBQueue] = []
    
    func getSortedQ(category:String) async throws {
        self.queues = try await queueManager.shared.getAllQSorted(category: category)
    }
    
}

struct Dashboard: View {
    
    @StateObject private var viewModel = DashBoardViewModel()
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                
                Group{
                    VStack{
                        Text("Renew Roadtax")
                        Text("and")
                        Text("Driving Licenses")
                    }.fontWeight(.heavy)
                    .font(.system(size: 17))
                    .padding(.horizontal)
                    
                    ZStack{
                        
                        Rectangle()
                            .fill(.white)
                            .opacity(0.9)
                            .frame(width: 370,height: 150)
                            .border(.black, width: 3)
                        
                        HStack{
                            
                            Spacer()
                            
                            HStack{
                                
                                //SERVING TOKEN
                                VStack{
                                    Text("SERVING")
                                    
                                    ZStack{
                                        Rectangle()
                                            .fill(.white)
                                            .opacity(0.9)
                                            .frame(width: 140,height: 100)
                                            .border(.black, width: 3)
                                        
                                        ForEach(viewModel.queues) { queue in
                                            if queue.status == "served", queue.category == "roadtax"{
                                                Text(queue.token ?? "")
                                                    .fontWeight(.heavy)
                                                    .font(.system(size: 27))
                                                    .padding(.horizontal)
                                            }
                                        }
                                        
                                    }
                                }
                                
                                Spacer()
                                
                                //ON HOLD TOKEN
                                VStack{
                                    Text("ON HOLD")
                                    
                                    ZStack{
                                        Rectangle()
                                            .fill(.white)
                                            .opacity(0.9)
                                            .frame(width: 140,height: 100)
                                            .border(.black, width: 3)
                                        
                                        ForEach(viewModel.queues) { queue in
                                            if queue.status == "hold", queue.category == "roadtax"{
                                                Text(queue.token ?? "")
                                                    .fontWeight(.heavy)
                                                    .font(.system(size: 27))
                                                    .padding(.horizontal)
                                            }
                                        }
                                        
                                    }
                                }
                                
                                
                            }.padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                }.task {
                    try? await viewModel.getSortedQ(category: "roadtax")
                }
                
                Group{
                    VStack{
                        Text("Pay Bill")
                            .fontWeight(.heavy)
                            .font(.system(size: 17))
                            .padding(.horizontal)
                    }
                    
                    ZStack{
                        
                        Rectangle()
                            .fill(.white)
                            .opacity(0.9)
                            .frame(width: 370,height: 150)
                            .border(.black, width: 3)
                        
                        HStack{
                            
                            Spacer()
                            
                            HStack{
                                
                                //SERVING TOKEN
                                VStack{
                                    Text("SERVING")
                                    
                                    ZStack{
                                        Rectangle()
                                            .fill(.white)
                                            .opacity(0.9)
                                            .frame(width: 140,height: 100)
                                            .border(.black, width: 3)
                                        
                                        ForEach(viewModel.queues) { queue in
                                            if queue.status == "served", queue.category == "paybill"{
                                                Text(queue.token ?? "")
                                                    .fontWeight(.heavy)
                                                    .font(.system(size: 27))
                                                    .padding(.horizontal)
                                            }
                                        }
                                        
                                    }
                                }
                                
                                
                                Spacer()
                                
                                //ON HOLD TOKEN
                                VStack{
                                    Text("ON HOLD")
                                    
                                    ZStack{
                                        Rectangle()
                                            .fill(.white)
                                            .opacity(0.9)
                                            .frame(width: 140,height: 100)
                                            .border(.black, width: 3)
                                        
                                        ForEach(viewModel.queues) { queue in
                                            if queue.status == "hold", queue.category == "paybill"{
                                                Text(queue.token ?? "")
                                                    .fontWeight(.heavy)
                                                    .font(.system(size: 27))
                                                    .padding(.horizontal)
                                            }
                                        }
                                        
                                    }
                                }
                                
                                
                                
                            }.padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                }.task {
                    try? await viewModel.getSortedQ(category: "paybill")
                }
                
                Group{
                    
                    VStack{
                        
                        Text("Send Parcel")
                        Text("and Pickup Parcel")
                        
                    }.fontWeight(.heavy)
                        .font(.system(size: 17))
                        .padding(.horizontal)
                    
                    ZStack{
                        
                        Rectangle()
                            .fill(.white)
                            .opacity(0.9)
                            .frame(width: 370,height: 150)
                            .border(.black, width: 3)
                        
                        HStack{
                            
                            Spacer()
                            
                            HStack{
                                
                                //SERVING TOKEN
                                VStack{
                                    Text("SERVING")
                                    
                                    ZStack{
                                        Rectangle()
                                            .fill(.white)
                                            .opacity(0.9)
                                            .frame(width: 140,height: 100)
                                            .border(.black, width: 3)
                                        
                                        ForEach(viewModel.queues) { queue in
                                            if queue.status == "served", queue.category == "parcel"{
                                                Text(queue.token ?? "")
                                                    .fontWeight(.heavy)
                                                    .font(.system(size: 27))
                                                    .padding(.horizontal)
                                            }
                                        }
                                        
                                    }
                                }
                                
                                
                                Spacer()
                                
                                //ON HOLD TOKEN
                                VStack{
                                    Text("ON HOLD")
                                    
                                    ZStack{
                                        Rectangle()
                                            .fill(.white)
                                            .opacity(0.9)
                                            .frame(width: 140,height: 100)
                                            .border(.black, width: 3)
                                        
                                        ForEach(viewModel.queues) { queue in
                                            if queue.status == "hold", queue.category == "parcel"{
                                                Text(queue.token ?? "")
                                                    .fontWeight(.heavy)
                                                    .font(.system(size: 27))
                                                    .padding(.horizontal)
                                            }
                                        }
                                        
                                    }
                                }
                                
                                
                                
                            }.padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                }.task {
                    try? await viewModel.getSortedQ(category: "parcel")
                }
                
            }.navigationTitle("QUEUEING FLOW")
            
        }.ignoresSafeArea()
        
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
