//
//  PaintPathState.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PaintPathStateInputs {
    var paintPathDidComplete: PublishRelay<[SNPathElement]> { get }
}

protocol PaintPathStateOutputs {
    var paint: Driver<PathInfo> { get }
}

protocol PaintPathStateType {
    var inputs: PaintPathStateInputs { get }
    var outputs: PaintPathStateOutputs { get }
}

class PaintPathState: PaintPathStateType, PaintPathStateInputs, PaintPathStateOutputs {
    
    // MARK: - Type
    var inputs: PaintPathStateInputs { return self }
    var outputs: PaintPathStateOutputs { return self }
    
    // MARK: - Inputs
    let paintPathDidComplete: PublishRelay<[SNPathElement]> = PublishRelay()
    
    // MARK: - Outputs
    let paint: Driver<PathInfo>
    
    private let repository: PaintPathRepositoryType
    private let disposeBag = DisposeBag()
    
    init(repository: PaintPathRepositoryType) {
        self.repository = repository
        
        self.paint = repository.outputs.paint
        
        self.paintPathDidComplete
            .asSignal()
            .emit(to: repository.inputs.paintPath)
            .disposed(by: disposeBag)
    }
}
