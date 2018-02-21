//
//  PaintViewModel.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PaintViewModelType {
    var paintPathState: PaintPathStateType { get }
    var paintPathEditState: PaintPathEditStateType { get }
    var paintPathColorState: PaintPathColorStateType { get }
    var paintSaveState: PaintSaveStateType { get }
}

class PaintViewModel: PaintViewModelType {
    
    typealias State = (
        paintPathState: PaintPathStateType,
        paintPathEditState: PaintPathEditStateType,
        paintPathColorState: PaintPathColorStateType,
        paintSaveState: PaintSaveStateType
    )
    
    // MARK: - States
    let paintPathState: PaintPathStateType
    let paintPathEditState: PaintPathEditStateType
    let paintPathColorState: PaintPathColorStateType
    let paintSaveState: PaintSaveStateType
    
    private let disposeBag = DisposeBag()
    
    init(state: State) {
        self.paintPathState = state.paintPathState
        
        self.paintPathEditState = state.paintPathEditState
        
        self.paintPathColorState = state.paintPathColorState
        
        self.paintSaveState = state.paintSaveState
    }
}
