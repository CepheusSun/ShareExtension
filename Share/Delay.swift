//
//  Delay.swift
//  SofaMovie-swift
//
//  Created by sunny on 2017/6/3.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation


typealias Task = (_ cancel: Bool) -> Void

@discardableResult
func delay(_ time: TimeInterval, task: @escaping () -> ()) -> Task? {
    
    func dispatch_later(block: @escaping () -> ()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    var closure: (() -> Void)? = task
    var result: Task?
    
    let delayedClosure: Task = { cancel in
        if let internalClosure = closure {
            if  cancel == false {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    
    return result
}

func cancel(_ task: Task?) {
    task?(true)
}
