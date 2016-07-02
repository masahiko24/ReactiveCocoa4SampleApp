//
//  UIAlertController+ReactiveCocoa.swift
//  ReactiveCocoa4SampleApp
//
//  Created by Masahiko Tsujita on 2016/07/01.
//  Copyright © 2016年 Masahiko Tsujita. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa

extension UIViewController {
    
    ///Creates and returns a signal producer that represents a task that presents a UIAlertViewController by the reciever.
    func presentAlert(title title: String?, message: String?, preferredStyle: UIAlertControllerStyle, actionTitle: String?, actionStyle: UIAlertActionStyle) -> SignalProducer<Void, NoError> {
        return SignalProducer<Void, NoError> { (observer, disposable) in
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: { (action) in
                observer.sendCompleted()
            })
            alert.addAction(action)
            alert.preferredAction = action
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}
