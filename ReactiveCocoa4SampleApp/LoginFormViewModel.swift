//
//  LoginFormViewModel.swift
//  ReactiveCocoa4SampleApp
//
//  Created by Masahiko Tsujita on 2016/06/26.
//  Copyright © 2016年 Masahiko Tsujita. All rights reserved.
//

import Foundation
import Result
import ReactiveCocoa

class LoginFormViewModel {
    
    var username = MutableProperty("")
    
    var password = MutableProperty("")
    
    var loginAction: Action<Void, String, Client.LoginError>!
    
    init() {
        let canLogin = combineLatest(
            username.signal,
            password.signal)
            .map { !$0.0.isEmpty && $0.1.characters.count >= 8 }
        
        loginAction = Action(enabledIf: AnyProperty(initialValue: false, signal: canLogin)) {
            return Client.sharedClient.login(username: self.username.value, password: self.password.value)
        }
    }

}
