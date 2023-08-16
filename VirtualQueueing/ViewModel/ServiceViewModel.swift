//
//  ServiceViewModel.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 30/06/2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class ServiceViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var queue: [DBQueue] = []
    @Published private(set) var userQueue: [DBQueue] = []
    
    func joinQueue(category: String) async throws{
        
        //get user's information
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await userManager.shared.getUser(userID: authDataResult.uid)
        
        do{
            try await queueManager.shared.joinQueue(userID: authDataResult.uid, id: UUID().uuidString, category: category)
        }
        
    }
    
    func leaveQ() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await userManager.shared.getUser(userID: authDataResult.uid)
        
        do{
            try await queueManager.shared.leaveQ(userID: authDataResult.uid)
        }catch{
            print(error)
        }
    }
    
    func getSortedQ(category:String) async throws {
        self.queue = try await queueManager.shared.getAllQSorted(category: category)
    }
    
    func getUserQueue() async throws{
        
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await userManager.shared.getUser(userID: authDataResult.uid)
        
        do{
            self.userQueue = try await queueManager.shared.getUserQ(userID: authDataResult.uid)
            
            for queue in userQueue {
                
                self.queue = try await queueManager.shared.getAllQSorted(category: queue.category)
                
            }
            
        } catch{
            print(error)
        }
        
    }
    
}
