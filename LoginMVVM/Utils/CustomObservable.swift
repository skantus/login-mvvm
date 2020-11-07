//
//  CustomObservable.swift
//  LoginMVVM
//
//  Created by Alejo Castaño on 07/11/2020.
//

import Foundation

class CustomObservable<T> {
    
    typealias Listener = (T) -> Void
    
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
