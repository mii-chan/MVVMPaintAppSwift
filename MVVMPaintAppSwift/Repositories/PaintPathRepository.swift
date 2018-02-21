//
//  PaintPathRepository.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PaintPathRepositoryInputs {
    var paintPath: PublishRelay<[SNPathElement]> { get }
    
    var changeColor: PublishRelay<PaintColorType> { get }
    
    var undoPath: PublishRelay<Void> { get }
    
    var redoPath: PublishRelay<Void> { get }
    
    var clearAllPaths: PublishRelay<Void> { get }
}

protocol PaintPathRepositoryOutputs {
    var paint: Driver<PathInfo> { get }
    
    var color: Driver<PaintColorType> { get }
    
    var canUndo: Driver<Bool> { get }
    
    var undo: Signal<PathInfo> { get }
    
    var canRedo: Driver<Bool> { get }
    
    var redo: Signal<PathInfo> { get }
    
    var clear: Signal<Void> { get }
}

protocol PaintPathRepositoryType {
    var inputs: PaintPathRepositoryInputs { get }
    var outputs: PaintPathRepositoryOutputs { get }
}

class PaintPathRepository: PaintPathRepositoryType, PaintPathRepositoryInputs, PaintPathRepositoryOutputs {
    
    // MARK: - Type
    var inputs: PaintPathRepositoryInputs { return self }
    var outputs: PaintPathRepositoryOutputs { return self }
    
    // MARK: - Inputs
    let paintPath: PublishRelay<[SNPathElement]> = PublishRelay()
    let changeColor: PublishRelay<PaintColorType> = PublishRelay()
    let undoPath: PublishRelay<Void> = PublishRelay()
    let redoPath: PublishRelay<Void> = PublishRelay()
    let clearAllPaths: PublishRelay<Void> = PublishRelay()
    
    // MARK: - Outputs
    let paint: Driver<PathInfo>
    let color: Driver<PaintColorType>
    let canUndo: Driver<Bool>
    let undo: Signal<PathInfo>
    let canRedo: Driver<Bool>
    let redo: Signal<PathInfo>
    let clear: Signal<Void>
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.paint = self.paintRelay.asDriver()
        self.color = self.colorRelay.asDriver()
        
        self.canUndo = self.canUndoRelay.asDriver()
        self.undo = self.undoRelay.asSignal()
        
        self.canRedo = self.canRedoRelay.asDriver()
        self.redo = self.redoRelay.asSignal()
        
        self.clear = self.clearRelay.asSignal()
        
        self.paintPath
            .asSignal()
            .emit(onNext: { [weak self] elements in
                guard let `self` = self else { return }
                
                let trimedElements = elements.count > 0 ? self.trimPaths(elements) : []
                let color = self.colorRelay.value
                
                self.paths.append((trimedElements, color))
                self.paintRelay.accept((trimedElements, color))
            })
            .disposed(by: disposeBag)
        
        self.changeColor
            .asSignal()
            .emit(onNext: { [weak self] colorType in
                guard let `self` = self else { return }
                
                self.colorRelay.accept(colorType)
            })
            .disposed(by: disposeBag)
        
        self.undoPath
            .asSignal()
            .emit(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                guard let (path, colorType) = self.paths.popLast() else { return }
                
                self.undoPaths.append((path, colorType))
                
                if self.undoPaths.count > self.undoLimit {
                    self.undoPaths.removeFirst()
                }
                
                self.undoRelay.accept((path, colorType))
            })
            .disposed(by: disposeBag)
        
        self.redoPath
            .asSignal()
            .emit(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                guard let (path, colorType) = self.undoPaths.popLast() else { return }
                
                self.paths.append((path, colorType))
                
                self.redoRelay.accept((path, colorType))
            })
            .disposed(by: disposeBag)
        
        self.clearAllPaths
            .asSignal()
            .emit(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                self.paths.removeAll()
                self.undoPaths.removeAll()
                
                self.clearRelay.accept(())
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private Relays
    private let paintRelay: BehaviorRelay<PathInfo> = BehaviorRelay(value: ([], PaintColorType.init()))
    private let colorRelay: BehaviorRelay<PaintColorType> = BehaviorRelay(value: PaintColorType.init())
    private let canUndoRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let undoRelay: PublishRelay<PathInfo> = PublishRelay()
    private let canRedoRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let redoRelay: PublishRelay<PathInfo> = PublishRelay()
    private let clearRelay: PublishRelay<Void> = PublishRelay()
    
    // MARK: - Private Properties
    private var paths: [([SNPathElement], PaintColorType)] = [] {
        didSet {
            paths.isEmpty ? self.canUndoRelay.accept(false) : self.canUndoRelay.accept(true)
        }
    }
    
    private var undoPaths: [([SNPathElement], PaintColorType)] = [] {
        didSet {
            undoPaths.isEmpty ? self.canRedoRelay.accept(false) : self.canRedoRelay.accept(true)
        }
    }
    
    private let undoLimit = 20
    
    // MARK: - Private Methods
    private func trimPaths(_ elements: [SNPathElement]) -> [SNPathElement] {
        let svg = SNPath.svg(from: elements)
        let es = SNPath.elements(from: svg)
        let path = SNPath.path(from: es)
        return SNPath.elements(from: path)
    }
}
