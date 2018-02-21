//
//  AutoLayout.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import UIKit

enum AutoLayout {
    static func fill(_ superview: UIView, with subview: UIView) {
        subview.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
}
