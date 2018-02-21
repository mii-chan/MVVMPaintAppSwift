//
//  RxSNDrawViewDelegateProxy.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSNDrawViewDelegateProxy: DelegateProxy<SNDrawView, SNDrawViewDelegate>, DelegateProxyType, SNDrawViewDelegate {
    
    weak private(set) var drawView: SNDrawView?
    
    init(drawView: SNDrawView) {
        self.drawView = drawView
        super.init(parentObject: drawView, delegateProxy: RxSNDrawViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxSNDrawViewDelegateProxy(drawView: $0) }
    }
    
    static func currentDelegate(for object: SNDrawView) -> SNDrawViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: SNDrawViewDelegate?, to object: SNDrawView) {
        return object.delegate = delegate
    }
    
    private var _didCompleteSubject: PublishSubject<[SNPathElement]>?
    
    var didCompleteSubject: PublishSubject<[SNPathElement]> {
        if let sbj = _didCompleteSubject {
            return sbj
        }
        
        let sbj = PublishSubject<[SNPathElement]>()
        _didCompleteSubject = sbj
        
        return sbj
    }
    
    func didComplete(_ elements: [SNPathElement]) -> Bool {
        if let sbj = _didCompleteSubject {
            sbj.onNext(elements)
        }
        
        _ = (self._forwardToDelegate as? SNDrawViewDelegate)?.didComplete(elements)
        
        return true
    }
    
    deinit {
        if let _didCompleteSubject = _didCompleteSubject {
            _didCompleteSubject.onCompleted()
        }
    }
}
