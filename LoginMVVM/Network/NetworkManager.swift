//
//  NetworkManager.swift
//  LoginMVVM
//
//  Created by Alejo Castaño on 07/11/2020.
//

import Foundation

protocol NetworkManagerProtocol {
    func loginWithCredentials(username: String, password: String) -> Void
}

class NetworkManager: NetworkManagerProtocol {
    
    func loginWithCredentials(username: String, password: String) {
        
        print("username: \(username)")
        print("password: \(password)")
        
        // Login service...
    }
}
