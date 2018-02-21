//
//  UIBarButtonItem+Highlight.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    var withHightlight: UIBarButtonItem {
        let color = UIColor.white.withAlphaComponent(0.2)
        let size = CGSize(width: 48, height: 48)
        self.setBackgroundImage(UIImage.fillImage(color: .clear, size: size), for: .normal, barMetrics: .default)
        self.setBackgroundImage(UIImage.fillImage(color: color, size: size), for: .highlighted, barMetrics: .default)
        
        return self
    }
}
