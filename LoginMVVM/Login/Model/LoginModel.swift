//
//  LoginModel.swift
//  LoginMVVM
//
//  Created by Alejo Castaño on 07/11/2020.
//

import Foundation

protocol LoginModelProtocol {
    var username: String { get set }
    var password: String { get set }
}

struct LoginModel: LoginModelProtocol {
    
    var username: String = ""
    var password: String = ""
}
