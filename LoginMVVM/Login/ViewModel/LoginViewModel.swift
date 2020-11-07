//
//  LoginViewModel.swift
//  LoginMVVM
//
//  Created by Alejo Castaño on 07/11/2020.
//

import Foundation

class LoginViewModel {
    
    private let networkManager: NetworkManager
    
    private var loginModel = LoginModel() {
        didSet {
            username = loginModel.username
            password = loginModel.password
        }
    }
    
    private var username = ""
    private var password = ""
    
    var credentialsInputErrorMessage: CustomObservable<String> = CustomObservable("")
    var isUsernameTextFieldHighLighted: CustomObservable<Bool> = CustomObservable(false)
    var isPasswordTextFieldHighLighted: CustomObservable<Bool> = CustomObservable(false)
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func updateCredentials(username: String, password: String, otp: String? = nil) {
        loginModel.username = username
        loginModel.password = password
    }
    
    func login(completion: @escaping (Error?) -> Void) {
        networkManager.loginWithCredentials(username: username, password: password)
        completion(nil)
    }
    
    func credentialsInput() -> CredentialsInputStatus {
        if username.isEmpty && password.isEmpty {
            credentialsInputErrorMessage.value = "Please provide username and password."
            return .Incorrect
        }
        
        if username.isEmpty {
            credentialsInputErrorMessage.value = "Username field is empty."
            isUsernameTextFieldHighLighted.value = true
            return .Incorrect
        }
        
        if password.isEmpty {
            credentialsInputErrorMessage.value = "Password field is empty."
            isPasswordTextFieldHighLighted.value = true
            return .Incorrect
        }
        
        return .Correct
    }
}

extension LoginViewModel {
    
    enum CredentialsInputStatus {
        case Correct
        case Incorrect
    }
}
