//
//  AuthServices.swift
//  Uber
//
//  Created by MEHEDI.R8 on 10/26/18.
//  Copyright © 2018 R8soft. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationComplete(false, error)
                return
            }

            let userData = ["provider": user.providerID, "email": user.email!] as Dictionary<String, Any>
            DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
            userCreationComplete(true, nil)
        }
    }
    
    

    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
}


