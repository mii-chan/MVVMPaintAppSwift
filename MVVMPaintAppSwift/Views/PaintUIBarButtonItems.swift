//
//  PaintUIBarButtonItems.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import UIKit

enum PaintUIBarButtonItems {
    
    static var clearButton: UIBarButtonItem {
        return UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_delete_36pt"),
            style: .plain,
            target: nil,
            action: nil
            ).withHightlight
    }
    
    static var undoButton: UIBarButtonItem {
        return UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_chevron_left_36pt"),
            style: .plain,
            target: nil,
            action: nil
            ).withHightlight
    }
    
    static var redoButton: UIBarButtonItem {
        return UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_chevron_right_36pt"),
            style: .plain,
            target: nil,
            action: nil
            ).withHightlight
    }
    
    static var blackColorButton: UIBarButtonItem {
        return UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_color_black_36dp").originalColor,
            style: .plain,
            target: nil,
            action: nil
            ).withHightlight
    }
    
    static var blueColorButton: UIBarButtonItem {
        return UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_color_blue_36dp").originalColor,
            style: .plain,
            target: nil,
            action: nil
            ).withHightlight
    }
    
    static var greenColorButton: UIBarButtonItem {
        return UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_color_green_36dp").originalColor,
            style: .plain,
            target: nil,
            action: nil
            ).withHightlight
    }
    
    static var yellowColorButton: UIBarButtonItem {
        return UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_color_yellow_36dp").originalColor,
            style: .plain,
            target: nil,
            action: nil
            ).withHightlight
    }
    
    static var redColorButton: UIBarButtonItem {
        return UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_color_red_36dp").originalColor,
            style: .plain,
            target: nil,
            action: nil
            ).withHightlight
    }
    
    static var saveButton: UIBarButtonItem {
        return UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_save_36pt"),
            style: .plain,
            target: nil,
            action: nil
            ).withHightlight
    }
    
    static var flexibleSpace: UIBarButtonItem {
        return UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
            ).withHightlight
    }
}
