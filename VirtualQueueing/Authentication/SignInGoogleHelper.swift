//
//  SignInGoogleHelper.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 02/04/2023.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel{
    let idToken: String
    let accessToken: String
    let name: String?
}

final class SignInGoogleHelper{
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel{
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }

        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }

        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        let name = gidSignInResult.user.profile?.name

        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name)
        
        return tokens
    }
}
