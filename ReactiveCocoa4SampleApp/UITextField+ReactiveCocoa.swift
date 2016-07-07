//
//  UITextField+ReactiveCocoa.swift
//  ReactiveCocoa4SampleApp
//
//  Created by Masahiko Tsujita on 2016/07/04.
//  Copyright © 2016年 Masahiko Tsujita. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa

extension UITextField {
    
    var textSignal: SignalProducer<String?, NoError> {
        return self.rac_textSignal().toSignalProducer()
            .map { $0 as? String }
            .flatMapError { _ in .empty }
    }
    
}
