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
    
    // MARK: - Initializers
    
    init() {
        self.username = MutableProperty("")
        self.password = MutableProperty("")
        
        self.usernameErrorUpdateAction = Action { SignalProducer(value: Void()) }
        self.passwordErrorUpdateAction = Action { SignalProducer(value: Void()) }
        
        self.error = Signal<String?, NoError>.merge(
            self.username.signal
                .map { $0.isEmpty ? "Username must not be empty." : nil }
                .sampleOn(self.usernameErrorUpdateAction.values),
            self.password.signal
                .map { $0.characters.count < 8 ? "Password length must be greater than or equal 8." : nil }
                .sampleOn(self.passwordErrorUpdateAction.values)
        )
        
        let canLogin = combineLatest(self.username.signal, self.password.signal)
            .map { !$0.0.isEmpty && $0.1.characters.count >= 8 }
        
        self.loginAction = Action(enabledIf: AnyProperty(initialValue: false, signal: canLogin)) { [unowned self] in
            return Client.sharedClient.login(username: self.username.value, password: self.password.value)
        }
    }

    // MARK: - Properties
    
    let username: MutableProperty<String>
    
    let password: MutableProperty<String>
    
    // MARK: - Actions
    
    private(set) var loginAction: Action<Void, String, Client.LoginError>!
    
    // MARK: - Error Descriptions Of
    
    /// The text describing issues of username and password
    let error: Signal<String?, NoError>
    
    /// The action to update the error message for username.
    private(set) var usernameErrorUpdateAction: Action<Void, Void, NoError>!
    
    /// The action to update the error message for password.
    private(set) var passwordErrorUpdateAction: Action<Void, Void, NoError>!
    
}
