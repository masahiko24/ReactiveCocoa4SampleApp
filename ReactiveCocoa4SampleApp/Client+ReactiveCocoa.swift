//
//  Client+ReactiveCocoa.swift
//  ReactiveCocoa4SampleApp
//
//  Created by Masahiko Tsujita on 2016/06/28.
//  Copyright © 2016年 Masahiko Tsujita. All rights reserved.
//

import Foundation
import Result
import ReactiveCocoa

extension Client {
    
    func login(username username: String, password: String) -> SignalProducer<String, LoginError> {
        return SignalProducer<String, LoginError> { (observer, disposable) in
            self.login(username: username, password: password) { result in
                switch result {
                case let .Success(value):
                    observer.sendNext(value)
                    observer.sendCompleted()
                    break
                case let .Failure(error):
                    observer.sendFailed(error)
                    break
                }
            }
        }
    }
    
}
