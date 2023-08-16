//
//  TabBarView.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 05/03/2023.
//
import SwiftUI

struct TabBar: View {
    
    @State var selectedIndex = 0
    
    @Binding var showSignInView: Bool
    
    let icon = ["house", "person.line.dotted.person", "gearshape.fill"]
    let name = ["Home", "Active Queue", "Setting"]
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            
            ZStack{
                
                switch selectedIndex {
                    
                case 0:
                    HomeView(showSignInView: $showSignInView)
                case 1:
                    ActiveQView(showSignInView: $showSignInView)
                default:
                    ProfileView(showSignInView: $showSignInView)
                    
                }
                
            }
            
            Spacer()
            
            Divider()
            
            HStack{
                ForEach(0..<3, id:\.self){ number in
                    
                    Spacer()
                    
                    Button {
                        self.selectedIndex = number
                    } label: {
                        
                        VStack{
                            Image(systemName: icon[number])
                                .font(.system(size: 22,
                                              weight: .regular,
                                              design: .monospaced))
                                .foregroundColor(selectedIndex == number ? .black: Color(UIColor.lightGray))
                            Text(name[number])
                                .padding(.horizontal)
                                .foregroundColor(selectedIndex == number ? .black: Color(UIColor.lightGray))
                                .fontWeight(.semibold)
                        }
                        
                    }
                    
                    Spacer()
                    
                }
            }
            .padding(.vertical, 10)
            .background(Color.white)
            .frame(width: 370)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
            
            
        }
        
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(showSignInView: .constant(false))
    }
}
