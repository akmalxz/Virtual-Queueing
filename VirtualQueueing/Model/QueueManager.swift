//
//  QueueManager.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 08/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBQueue: Identifiable ,Codable {
    var id: String
    let userID: String
    let category: String
    let token: String?
    let status: String?
    let estWaitTime: Int?       //how long they need to wait
    let timeLimit: Int?         //if they missed their token, this variable will updated to 60minute
    let dateJoined: Timestamp?  //when they joined
    let timeServe: Timestamp?   //when will they start get to serve
    let timeFinished: Timestamp //when will they finished being served
    
}

final class queueManager{
    
    enum MyError:Error {
        case roadtaxError
    }
    
    static let shared = queueManager()
    
    private init(){ }
    
    private let queueCollections = Firestore.firestore().collection("queue")
    
    private func queueDocument(queueID: String) -> DocumentReference{
        queueCollections.document(queueID)
    }
    
    
    func checkUserExist(userID: String) async throws -> Bool {
        let snapshot = try await queueCollections
            .whereField("userID", isEqualTo: userID)
            .getDocuments()
        
        return !snapshot.isEmpty
    }
    
    func joinQueue(userID: String, id: String, category: String) async throws {
        
        // Check if the user already exists in the queue
        let userExists = try await checkUserExist(userID: userID)
        
        if userExists {
            throw MyError.roadtaxError
        } else {
            // Fetch the first document from the queue collection
            let querySnapshot = try await queueCollections.order(by: "token", descending: true).limit(to: 1).getDocuments()
            
            let currentToken: String
            var tempToken: Int
            
            if let document = querySnapshot.documents.first {
                // Get the last token number and increment it by 1
                tempToken = (document["token"] as? String).flatMap(Int.init) ?? 0
                tempToken += 1
            } else {
                currentToken = "6000"
                tempToken = (Int(currentToken) ?? 0) + 1
            }
            
            let status: String
            
            let tempStatus = try await queueCollections.whereField("status", isEqualTo: "served").whereField("category", isEqualTo: category).getDocuments()
            
            if tempStatus.isEmpty {
                status = "served"
            } else {
                status = "waiting"
            }
            
            // Query the queue collection for the given category
            let snapshot = queueCollections.whereField("category", isEqualTo: category)
            
            // Calculate estimated wait time
            let waitingSnapshot = try await snapshot.getDocuments()
            let estTime = Double(waitingSnapshot.documents.count) * 2.0 //temporary to shorten the queue process
            
            // Calculate timestamps for serving and finishing
            let currentDate = Date()
            let calendar = Calendar.current
            
            //serving time
            let updatedDate = calendar.date(byAdding: .minute, value: Int(estTime), to: currentDate)!
            let timeToServed = Timestamp(date: updatedDate)
            
            //finish serving time
            let finish = calendar.date(byAdding: .minute, value: 2, to: updatedDate)!
            let timeToFinish = Timestamp(date: finish)
            
            // Create a new queue object
            let newQ = DBQueue(
                id: id,
                userID: userID,
                category: category,
                token: String(tempToken),
                status: status,
                estWaitTime: Int(estTime),
                timeLimit: 0,
                dateJoined: Timestamp(),
                timeServe: timeToServed,
                timeFinished: timeToFinish
            )
            
            do {
                try queueDocument(queueID: id).setData(from: newQ, merge: false)
                print("Document added")
            } catch {
                print(error)
            }
        }
    }

    func deleteQueue(category: String) {
        // Deletes a queue based on the specified category
        //- Parameters:
        // - category: The category of the queue to be deleted.
        
        // Fetch the 1 oldest documents from the queue collection for the given category
        queueCollections
            .order(by: "dateJoined", descending: false)
            .limit(to: 1)
            .whereField("category", isEqualTo: category)
            .getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    guard let document = querySnapshot?.documents.first else {
                        print("No documents found.")
                        return
                    }
                    print("Latest document: \(document.data())")
                    
                    let docID = document["id"] as? String ?? ""
                    
                    // Delete the document from the queue collection
                    self.queueCollections.document(docID).delete { error in
                        if let error = error {
                            print("Error removing document: \(error)")
                        } else {
                            print("Document successfully removed!")
                            
                            // Update the queue after deleting
                            Task {
                                do {
                                    try await self.updateQFinish(category: category)
                                } catch {
                                    print("Error updating queue after deletion: \(error)")
                                }
                            }
                        }
                    }
                }
            }
    }
    
    func updateQMissed(category: String) async throws {
        //Updates the status of the oldest queue document with the specified category to "hold".
        //- Parameters:
        //   - category: The category of the queue to be updated.
        //- Throws: Throws an error if there's an issue retrieving or updating the document.
        
        // Fetch the oldest document from the queue collection for the given category
        let querySnapshot = try await queueCollections
            .order(by: "dateJoined", descending: false)
            .limit(to: 1)
            .whereField("category", isEqualTo: category)
            .getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            print("No documents found.")
            return
        }
        
        let docID = document.documentID
        
        let data: [String: Any] = [
            "status": "hold"
        ]
        
        do{
            // Update the document's data in the queue collection
            self.queueDocument(queueID: docID).updateData(data) { (error) in
                if let error = error {
                    print("Error updating the data: \(error)")
                } else {
                    print("Successfully updated!")
                    
                    // Fetch data after updating the queue
                    Task {
                        do {
                            try await self.fetchData(category: category)
                        } catch {
                            print("Error fetching updated queue data: \(error)")
                        }
                    }
                }
            }
        }
        
    }
    
    func fetchData(category: String) async throws {
        // Fetches and processes queue documents based on the specified category
        // - Parameters:
        //    - category: The category of the queue to be fetched.
        // - Throws: Throws an error if there's an issue retrieving or updating the document.
        
        // Construct the query to fetch queue documents for the given category
        let query = queueCollections
            .order(by: "dateJoined", descending: false)
            .limit(to: 3)
            .whereField("category", isEqualTo: category)
        
        do {
            let querySnapshot = try await query.getDocuments()
            
            let documents = querySnapshot.documents
            
            if !documents.isEmpty {
                let secondLastDocument = documents[documents.count - 2]
                // Process the second-to-last document
                print("Second-to-last document: \(secondLastDocument.data())")
                
                let docID = secondLastDocument.documentID
                
                let data: [String: Any] = [
                    "status": "served"
                ]
                
                // Update the document's data in the queue collection
                try await self.queueDocument(queueID: docID).updateData(data)
                
            } else {
                print("Not enough documents in the collection.")
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    func updateQFinish(category: String) async throws {
        // Updates the status of the oldest queue document with the specified category to "served"
        // - Parameters:
        //    - category: The category of the queue to be updated.
        // - Throws: Throws an error if there's an issue retrieving or updating the document.
        
        // Fetch the oldest document from the queue collection for the given category
        let querySnapshot = try await queueCollections
            .order(by: "dateJoined", descending: false)
            .limit(to: 1)
            .whereField("category", isEqualTo: category)
            .getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            print("No documents found.")
            return
        }
        
        let docID = document.documentID
        
        let data: [String: Any] = [
            "status": "served"
        ]
        
        // Update the document's data in the queue collection
        try await self.queueDocument(queueID: docID).updateData(data)
    }
    
    func leaveQ(userID: String) async throws {
        do {
            let querySnapshot = try await queueCollections
                .whereField("userID", isEqualTo: userID)
                .getDocuments()
            
            guard let document = querySnapshot.documents.first else {
                print("No documents found.")
                return
            }
            
            let docID = document["id"] as? String ?? ""
            
            try await queueCollections.document(docID).delete()
            
            print("Document successfully removed!")
        } catch {
            print("Error: \(error)")
        }
    }
    
    func getUserQ(userID:String) async throws -> [DBQueue]{
        let snapshot = try await queueCollections
            .whereField("userID", isEqualTo: userID)
            .getDocuments()
        
        var queues: [DBQueue] = []
        
        for document in snapshot.documents{
            
            let queue = try document.data(as: DBQueue.self)
            queues.append(queue)
            
        }
        return queues
    }
    
    func getAllQSorted(category: String) async throws -> [DBQueue] {
        let snapshot = try await queueCollections
            .order(by: "dateJoined", descending: false)
            .whereField("category", isEqualTo: category)
            .getDocuments()
        
        var queues: [DBQueue] = [] //initializes an empty array
        
        for document in snapshot.documents{
            
            let queue = try document.data(as: DBQueue.self)
            queues.append(queue)
            
        }
        return queues
    }
    
    func checkDocExists() async throws -> Bool {
        
        do {
            let querySnapshot = try await queueCollections.getDocuments()
            let documents = querySnapshot.documents
            
            return !documents.isEmpty
        } catch {
            print("Error getting documents: \(error)")
            throw error
        }
        
    }
    
    func getQueue() async throws -> [DBQueue] {
        let snapshot = try await queueCollections
            .order(by: "dateJoined", descending: false)
            .getDocuments()
        
        var queues: [DBQueue] = [] //initializes an empty array
        
        for document in snapshot.documents{
            
            let queue = try document.data(as: DBQueue.self)
            queues.append(queue)
            
        }
        return queues
    }
    
}
