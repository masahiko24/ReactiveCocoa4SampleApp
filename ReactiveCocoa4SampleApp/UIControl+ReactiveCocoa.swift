//
//  UIControl+ReactiveCocoa.swift
//  ReactiveCocoa4SampleApp
//
//  Created by Masahiko Tsujita on 2016/07/08.
//  Copyright © 2016年 Masahiko Tsujita. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa

extension UIControl {
    
    func signal(forControlEvents controlEvents: UIControlEvents) -> SignalProducer<Void, NoError> {
        return self.rac_signalForControlEvents(controlEvents).toSignalProducer()
            .map { _ in }
            .flatMapError { _ in .empty }
    }
    
}
