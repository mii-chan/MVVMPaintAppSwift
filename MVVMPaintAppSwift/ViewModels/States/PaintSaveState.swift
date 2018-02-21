//
//  PaintSaveState.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PaintSaveStateInputs {
    var saveButtonTapped: PublishRelay<Void> { get }
}

protocol PaintSaveStateOutputs {
    var save: Signal<Void> { get }
}

protocol PaintSaveStateType {
    var inputs: PaintSaveStateInputs { get }
    var outputs: PaintSaveStateOutputs { get }
}

class PaintSaveState: PaintSaveStateType, PaintSaveStateInputs, PaintSaveStateOutputs {
    
    // MARK: - Type
    var inputs: PaintSaveStateInputs { return self }
    var outputs: PaintSaveStateOutputs { return self }
    
    // MARK: - Inputs
    let saveButtonTapped: PublishRelay<Void> = PublishRelay()
    
    // MARK: - Outputs
    let save: Signal<Void>
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.save = self.saveButtonTapped.asSignal()
    }
}
