//
//  RoadTaxQModel.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 12/04/2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class RoadTaxQViewModel: ObservableObject{
    
    @Published private(set) var user: DBUser? = nil
    @Published var list = [Queue]()
    @Published private(set) var queue: Queue? = nil
    
    func loadCurrentUser() async throws{
        
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await userManager.shared.getUser(userID: authDataResult.uid)
        
    }
    
    private let queueCollection = Firestore.firestore().collection("users")
    
    private func queueDocument(queueID: String) -> DocumentReference{
        queueCollection.document(queueID)
    }
    
}


