//  UserManager.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 07/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userID: String
    let email: String?
    let name: String?
    let phone: String?
    let photoURL: String?
    let dateCreated: Date?
    
    init(auth: AuthDataResultModel) {
        self.userID = auth.uid
        self.email = auth.email
        self.name = auth.name
        self.phone = auth.phone
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
    }
    
    init(
        userID: String,
        email: String? = nil,
        name: String? = nil,
        phone: String? = nil,
        photoURL: String? = nil,
        isQActive: Bool? = false,
        dateCreated: Date? = nil
    ) {
        self.userID = userID
        self.email = email
        self.name = name
        self.phone = phone
        self.photoURL = photoURL
        self.dateCreated = dateCreated
    }
    
}

final class userManager {
    
    static let shared = userManager()
    
    private init (){ }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userID: String) -> DocumentReference{
        userCollection.document(userID)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    //create new user's information from database
    func createNewUser(user: DBUser) async throws {
        try userDocument(userID: user.userID).setData(from: user, merge: false, encoder: encoder)
    }
    
    //retrieve user's information from database into DBUser by userId
    func getUser(userID: String) async throws -> DBUser{

        let snapshot = try await userDocument(userID: userID).getDocument()

        guard let data = snapshot.data() else {
            throw URLError(.badServerResponse)
        }

        let email = data["email"] as? String
        let name = data["name"] as? String
        let phone = data["phone"] as? String
        let photoURL = data["photoURL"] as? String
        let dateCreated = data["date_created"] as? Date

        return DBUser(userID: userID, email: email, name: name, phone: phone, photoURL: photoURL, dateCreated: dateCreated)
    }
    
    //update the whole document by merging the latest doc with the old one
    func updateUser(user: DBUser) async throws{
        try userDocument(userID: user.userID).setData(from: user, merge: true, encoder: encoder)
    }
    
    //update only the specified field in a document
    func updateUser(userId: String, phone: String, name: String) async throws{
        
        let data : [String: Any] = [
            //"phone" exactly same as field in doc
            "phone" : phone,
            "name" : name
        ]
        
        try await userDocument(userID: userId).updateData(data)
    }
    
    
}
