//
//  SNDrawView+Rx.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: SNDrawView {
    
    /// Reactive wrapper for delegate`
    public var delegate: DelegateProxy<SNDrawView, SNDrawViewDelegate> {
        return RxSNDrawViewDelegateProxy.proxy(for: base)
    }
    
    /// Reactive wrapper for delegate method `didComplete`
    public var didComplete: ControlEvent<[SNPathElement]> {
        let source = RxSNDrawViewDelegateProxy.proxy(for: base).didCompleteSubject
        return ControlEvent(events: source)
    }
}
