//
//  LoginFormViewController.swift
//  ReactiveCocoa4SampleApp
//
//  Created by Masahiko Tsujita on 2016/06/25.
//  Copyright © 2016年 Masahiko Tsujita. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa

class LoginFormViewController: UIViewController {
    
    // MARK: - Login Form User Interfaces
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Cancel Button
    
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    
    // MARK: - ViewModel
    
    var viewModel: LoginFormViewModel! {
        didSet {
            // ignore nil
            guard self.viewModel != nil else {
                return
            }
            
            // bind viewmodel
            
            // bind username and password
            viewModel.username <~ usernameField.textSignal
                .map { $0 ?? "" }
            viewModel.password <~ passwordField.textSignal
                .map { $0 ?? "" }
            
            // bind login action
            let loginAction = viewModel.loginAction
            loginButton.rac_command = toRACCommand(Action(enabledIf: loginAction.enabled, { _ in
                return loginAction.apply()
                    .map { $0 as AnyObject }
            }))
            
            // bind cancel action
            cancelButtonItem.rac_command = toRACCommand(Action({ [unowned self] (button: AnyObject?) -> SignalProducer<AnyObject, NoError> in
                self.pipe.1.sendInterrupted()
                return .empty
            }))
            
            // bind error
            
            usernameField.signal(forControlEvents: .EditingDidEnd)
                .startWithNext { [unowned self] _ in self.viewModel.usernameErrorUpdateAction.apply().start() }
            
            passwordField.signal(forControlEvents: .EditingDidEnd)
                .startWithNext { [unowned self] _ in self.viewModel.passwordErrorUpdateAction.apply().start() }
            
            viewModel.error.observeNext { [unowned self] (error) in
                self.errorLabel.text = error
            }
            
            // subscribe login results
            loginAction.values.observeNext { [unowned self] (token) in
                self.presentAlert(title: "Login Succeeded", message: "Access token is \(token).", preferredStyle: .Alert, actionTitle: "OK", actionStyle: .Default)
                    .startWithCompleted { [unowned self] in self.pipe.1.sendCompleted() }
            }
            loginAction.errors.observeNext { [unowned self] (error) in
                self.presentAlert(title: "Login Failed", message: "Please confirm that both username and password are correct.", preferredStyle: .Alert, actionTitle: "OK", actionStyle: .Default)
                    .start()
            }
            
            // move to next field on tapping return key in inputting username
            self.usernameField.signal(forControlEvents: .EditingDidEndOnExit)
                .startWithNext { [unowned self] _ in self.passwordField.becomeFirstResponder() }
            
            // perform login on tapping return key in inputting password
            self.passwordField.signal(forControlEvents: .EditingDidEndOnExit)
                .startWithNext { [unowned self] _ in
                    let loginAction = self.viewModel.loginAction
                    if loginAction.enabled.value {
                        loginAction.apply().start()
                    }
                }
        }
    }
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LoginFormViewModel()
    }
    
    // MARK: - Promise
    
    private let pipe = Signal<String, NoError>.pipe()
    var signal: Signal<String, NoError> { return pipe.0 }
    
}
