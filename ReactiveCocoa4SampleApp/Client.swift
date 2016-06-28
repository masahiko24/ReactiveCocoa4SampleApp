//
//  Client.swift
//  ReactiveCocoa4SampleApp
//
//  Created by Masahiko Tsujita on 2016/06/27.
//  Copyright © 2016年 Masahiko Tsujita. All rights reserved.
//

import Foundation
import Result

final class Client {
    
    enum LoginError: ErrorType {
        case UsernameNotFound
        case PasswordNotValid
    }
    
    private init() {
        
    }
    
    static let sharedClient: Client = Client()
    
    private static let ValidUsername = "johna"
    private static let ValidPassword = "12345678"
    
    func login(username username: String, password: String, callback: (Result<String, LoginError>) -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                guard username == Client.ValidUsername else {
                    callback(Result<String, LoginError>(error: .UsernameNotFound))
                    return
                }
                guard password == Client.ValidPassword else {
                    callback(Result<String, LoginError>(error: .PasswordNotValid))
                    return
                }
                callback(Result<String, LoginError>(value: NSUUID.init().UUIDString))
            }
        }
    }
    
}
