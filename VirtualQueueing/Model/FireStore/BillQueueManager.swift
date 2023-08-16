//
//  BillQueueManager.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 13/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

//  This file manager is only for Pay Bill Queueing processes

struct BillQueue: Identifiable ,Codable {
    var id: String
    let userID: String
    let token: String?
    let status: String?
    let estWaitTime: Int?
    let dateJoined: Timestamp?
    
}

final class BillQueueManager{
    
    enum MyError: Error {
        case someError
    }
    
    static let shared = BillQueueManager()
    
    private init(){ }
    
    private let queueCollection = Firestore.firestore().collection("paybillqueue")
    
    private func queueDocument(queueID: String) -> DocumentReference{
        queueCollection.document(queueID)
    }
    
    func joinQueue(userID:String, id:String) async throws{
        
        //check user existence in the queue
        let temp = try await checkUserExist(userID: userID)
        
        do {
            //if user already exist in a queue
            if temp {
                throw MyError.someError
            //else add user into the queue
            } else {
                queueCollection.order(by: "dateJoined", descending: true).limit(to: 1).getDocuments() { (querySnapshot, error) in
                    
                    if let error = error {
                        print("Error getting documents \(error)")
                    } else {
                        guard let document = querySnapshot?.documents.first else {
                            print("No Document found")
                            return
                        }
                        
                        //get the last token number
                        var tempToken = Int(document["token"] as? String ?? "")
                        //increment by 1
                        tempToken!+=1
                        
                        let snapshot = self.queueCollection
                        var estTime: Double = 0.0
                        
                        //count the number people in waiting
                        snapshot.getDocuments { (snapshot, error) in
                            if let error = error {
                                print("Error getting documents: \(error.localizedDescription)")
                            } else {
                                guard let snapshot = snapshot else { return }
                                
                                estTime = Double(snapshot.documents.count) * 10.0
                                
//                                if estTime > 60 {
//                                    let hour = round((estTime.truncatingRemainder(dividingBy: 1440)) / 60)
//                                    let minute = estTime.truncatingRemainder(dividingBy: 60)
//                                    estTime = hour + minute
//                                }
                                
//                                let newQ = DBQueue(id: id, userID: userID, token: String(tempToken ?? 0), status: "waiting", estWaitTime: Int(estTime), dateJoined: Timestamp())
//
//                                Task{
//                                    try self.queueDocument(queueID: id).setData(from: newQ, merge: false) { error in
//                                        if let error = error{
//                                            print(error)
//                                        } else {
//                                            print("document added")
//                                        }
//                                    }
//                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkUserExist(userID: String) async throws -> Bool {
        let snapshot = try await queueCollection.whereField("userID", isEqualTo: userID).getDocuments()
        
        return !snapshot.isEmpty
    }
    
    func getAllQ() async throws -> [BillQueue]{
        let snapshot = try await queueCollection.getDocuments()
        var queues: [BillQueue] = []
        
        for document in snapshot.documents{
            
            let queue = try document.data(as: BillQueue.self)
            queues.append(queue)
            
        }
        return queues
    }
    
    func getAllQSorted() async throws -> [BillQueue] {
        let snapshot = try await queueCollection.order(by: "token", descending: false).getDocuments()
        var queues: [BillQueue] = []
        
        for document in snapshot.documents{
            
            let queue = try document.data(as: BillQueue.self)
            queues.append(queue)
            
        }
        return queues
    }
    
    func deleteQueue() {
        
        queueCollection.order(by: "dateJoined", descending: false).limit(to: 1).getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("No documents found.")
                    return
                }
                print("Latest document: \(document.data())")
                
                let docID = document["id"] as? String ?? ""
                
                self.queueCollection.document(docID).delete() { error in
                    if let error = error {
                        print("Error removing document: \(error)")
                    } else {
                        print("Document successfully removed!")
                        
                        Task{
                            do{
                                try await self.updateQStatus()
                            }
                        }
                        
                        
                    }
                }
                
            }
            
        }
        
    }
    
    //update only the specified field in a document
    func updateQStatus() async throws{
        
        await MainActor.run{
            queueCollection.order(by: "dateJoined", descending: false).limit(to: 1).getDocuments() { (querySnapshot, error) in
                
                Task{
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        guard let document = querySnapshot?.documents.first else {
                            print("No documents found.")
                            return
                        }
                        print("Latest document: \(document.data())")
                        
                        let docID = document["id"] as? String ?? ""
                        
                        let data : [String:Any] = [
                            "status" : "served"
                        ]
                        
                        try await self.queueDocument(queueID: docID).updateData(data)
                    }
                }
                
            }
        }
        
    }
    
}
