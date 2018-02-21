//
//  UIImage+Color.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import UIKit

extension UIImage {
    var originalColor: UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}
