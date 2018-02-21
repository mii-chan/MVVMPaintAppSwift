//
//  PaintView.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import UIKit

class PaintView: SNDrawView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.white
        self.shapeLayer.lineWidth = 5.0
        self.shapeLayer.strokeColor = ColorResolver.resolve(PaintColorType.init())?.cgColor
        self.builder.minSegment = 0
    }
}
