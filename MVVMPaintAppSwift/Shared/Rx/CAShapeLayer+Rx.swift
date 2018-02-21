//
//  CAShapeLayer+Rx.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: CAShapeLayer {
    
    /// Bindable sink for `strokeColor` property
    public var strokeColor: Binder<CGColor?> {
        return Binder(self.base) { layer, value in
            layer.strokeColor = value
        }
    }
    
}
