//
//  PaintPathEditState.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PaintPathEditStateInputs {
    var undoButtonTapped: PublishRelay<Void> { get }
    
    var redoButtonTapped: PublishRelay<Void> { get }
    
    var clearButtonTapped: PublishRelay<Void> { get }
}

protocol PaintPathEditStateOutputs {
    var canUndo: Driver<Bool> { get }
    
    var undo: Signal<PathInfo> { get }
    
    var canRedo: Driver<Bool> { get }
    
    var redo: Signal<PathInfo> { get }
    
    var clear: Signal<Void> { get }
}

protocol PaintPathEditStateType {
    var inputs: PaintPathEditStateInputs { get }
    var outputs: PaintPathEditStateOutputs { get }
}

class PaintPathEditState: PaintPathEditStateType, PaintPathEditStateInputs, PaintPathEditStateOutputs {
    
    // MARK: - Type
    var inputs: PaintPathEditStateInputs { return self }
    var outputs: PaintPathEditStateOutputs { return self }
    
    // MARK: - Inputs
    let undoButtonTapped: PublishRelay<Void> = PublishRelay()
    let redoButtonTapped: PublishRelay<Void> = PublishRelay()
    let clearButtonTapped: PublishRelay<Void> = PublishRelay()
    
    // MARK: - Outputs
    let canUndo: Driver<Bool>
    let undo: Signal<PathInfo>
    let canRedo: Driver<Bool>
    let redo: Signal<PathInfo>
    let clear: Signal<Void>
    
    private let repository: PaintPathRepositoryType
    private let disposeBag = DisposeBag()
    
    init(repository: PaintPathRepositoryType) {
        self.repository = repository
        
        self.canUndo = repository.outputs.canUndo
        self.undo = repository.outputs.undo
        
        self.canRedo = repository.outputs.canRedo
        self.redo = repository.outputs.redo
        
        self.clear = repository.outputs.clear
        
        undoButtonTapped
            .asSignal()
            .emit(to: repository.inputs.undoPath)
            .disposed(by: disposeBag)
        
        redoButtonTapped
            .asSignal()
            .emit(to: repository.inputs.redoPath)
            .disposed(by: disposeBag)
        
        clearButtonTapped
            .asSignal()
            .emit(to: repository.inputs.clearAllPaths)
            .disposed(by: disposeBag)
    }
}
