//
//  PaintPathColorState.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PaintPathColorStateInputs {
    var changeColorButtonTapped: PublishRelay<PaintColorType> { get }
}

protocol PaintPathColorStateOutputs {
    var color: Driver<PaintColorType> { get }
}

protocol PaintPathColorStateType {
    var inputs: PaintPathColorStateInputs { get }
    var outputs: PaintPathColorStateOutputs { get }
}

class PaintPathColorState: PaintPathColorStateType, PaintPathColorStateInputs, PaintPathColorStateOutputs {
    
    // MARK: - Type
    var inputs: PaintPathColorStateInputs { return self }
    var outputs: PaintPathColorStateOutputs { return self }
    
    // MARK: - Inputs
    let changeColorButtonTapped: PublishRelay<PaintColorType> = PublishRelay()
    
    // MARK: - Outputs
    let color: Driver<PaintColorType>
    
    private let repository: PaintPathRepositoryType
    private let disposeBag = DisposeBag()
    
    init(repository: PaintPathRepositoryType) {
        self.repository = repository
        
        self.color = repository.outputs.color
        
        self.changeColorButtonTapped
            .asSignal()
            .emit(to: repository.inputs.changeColor)
            .disposed(by: disposeBag)
    }
}
