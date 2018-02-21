//
//  ColorResolver.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import UIKit

enum ColorResolver {
    static func resolve(_ colorType: PaintColorType) -> UIColor? {
        switch colorType {
        case .black:
            return UIColor(named: "color_black")
        case .blue:
            return UIColor(named: "color_blue")
        case .green:
            return UIColor(named: "color_green")
        case .yellow:
            return UIColor(named: "color_yellow")
        case .red:
            return UIColor(named: "color_red")
        }
    }
}
