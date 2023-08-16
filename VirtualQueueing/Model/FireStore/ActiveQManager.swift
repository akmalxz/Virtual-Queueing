//
//  ActiveQManager.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 11/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ActiveQueue: Identifiable ,Codable {
    var id: String
    let userID: String
    let category: String
    let token: String?
    let status: String?
    let estWaitTime: Int?
    let dateJoined: Timestamp?
    
}

final class ActiveQManager{
    
    static let shared = ActiveQManager()
    
    private init(){}
    
    
    func getAllQSorted(userID:String) async throws -> [ActiveQueue] {
        let snapshot = try await Firestore.firestore().collection("queue").whereField("userID", isEqualTo: userID).getDocuments()
        var queues: [ActiveQueue] = []
        
        for document in snapshot.documents{
            
            let queue = try document.data(as: ActiveQueue.self)
            queues.append(queue)
            
        }
        return queues
    }
    
}
