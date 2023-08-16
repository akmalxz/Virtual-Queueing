//
//  HomeView.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 04/03/2023.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @Binding var showSignInView: Bool
    
    @State private var showSignOutAlert = false
    
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
                            
                            Image("License-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150)
                            
                            VStack{
                                
                                VStack{
                                    Text("Renew Roadtax")
                                        .fontWeight(.heavy)
                                        .font(.system(size: 20))
                                    Text("and")
                                        .fontWeight(.heavy)
                                        .font(.system(size: 20))
                                    Text("Driving Licenses")
                                        .fontWeight(.heavy)
                                        .font(.system(size: 20))
                                    
                                    NavigationLink(destination: RoadTaxQView(showSignInView: $showSignInView) , label: {
                                        
                                        HStack{
                                            Text("View")
                                            Image(systemName: "arrow.right")
                                            
                                        }.foregroundColor(.black)
                                        
                                        
                                    })
                                    
                                }
                                
                            }
                            
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
                            
                            Image("bill-icon1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150)
                                .foregroundColor(.blue)
                            
                            VStack{
                                
                                Text("Pay Bill")
                                    .fontWeight(.heavy)
                                    .font(.system(size: 20))
                                
                                NavigationLink(destination: PayBillQView(showSignInView: $showSignInView) , label: {
                                    
                                    HStack{
                                        Text("View")
                                        Image(systemName: "arrow.right")
                                        
                                    }.foregroundColor(.black)
                                    
                                })
                            }
                            Spacer()
                        }.padding(.trailing, 50.0)
                        
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
                            
                            Image("Parcel-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150)
                                .foregroundColor(.brown)
                            
                            VStack{
                                
                                Text("Send Parcel")
                                    .fontWeight(.heavy)
                                    .font(.system(size: 20))
                                
                                Text("and Pickup Parcel")
                                    .fontWeight(.heavy)
                                    .font(.system(size: 20))
                                
                                NavigationLink(destination: ParcelQView(showSignInView: $showSignInView) , label: {
                                    
                                    HStack{
                                        Text("View")
                                        Image(systemName: "arrow.right")
                                        
                                    }.foregroundColor(.black)
                                    
                                })
                                
                            }
                            
                            Spacer()
                            
                        }
                        
                    }
                    
                }
                
            }.navigationTitle("SELECT SERVICES")
            
        }.ignoresSafeArea()
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showSignInView: .constant(false))
    }
}
