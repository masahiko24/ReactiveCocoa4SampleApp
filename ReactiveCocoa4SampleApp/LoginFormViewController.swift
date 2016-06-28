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
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    
    var viewModel = LoginFormViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usernameSignal = usernameField.rac_textSignal().toSignalProducer()
            .map { $0 as! String }
            .flatMapError { _ in SignalProducer<String, NoError>.empty }
        
        let passwordSignal = passwordField.rac_textSignal().toSignalProducer()
            .map { $0 as! String }
            .flatMapError { _ in SignalProducer<String, NoError>.empty }
        
        viewModel.username <~ usernameSignal
        viewModel.password <~ passwordSignal
        
        let action = viewModel.loginAction
        
        loginButton.rac_command = toRACCommand(Action(enabledIf: action.enabled, { _ in
            return action.apply().map { $0 as AnyObject }
        }))
        
        cancelButtonItem.rac_command = toRACCommand(Action({ (button: AnyObject?) -> SignalProducer<AnyObject, NoError> in
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            return SignalProducer<AnyObject, NoError>.empty
        }))
        
        action.values.observeNext { (token) in
            print("login succeeded. auth token is \(token)")
        }
        
        action.errors.observeNext { (error) in
            print("login failed.")
        }
        
    }
    
}
