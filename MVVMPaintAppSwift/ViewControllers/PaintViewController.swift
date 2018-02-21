//
//  PaintViewController.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PaintViewController: UIViewController {
    
    let clearButton: UIBarButtonItem
    let saveButton: UIBarButtonItem
    
    let paintView: PaintView
    
    let undoButton: UIBarButtonItem
    let redoButton: UIBarButtonItem
    
    let blackColorButton: UIBarButtonItem
    let blueColorButton: UIBarButtonItem
    let greenColorButton: UIBarButtonItem
    let yellowColorButton: UIBarButtonItem
    let redColorButton: UIBarButtonItem
    
    private var paintLayers = [CALayer]()
    
    private let viewModel: PaintViewModelType
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: PaintViewModelType) {
        self.viewModel = viewModel
        
        self.clearButton = PaintUIBarButtonItems.clearButton
        self.saveButton = PaintUIBarButtonItems.saveButton
        
        self.paintView = PaintView()
        
        self.undoButton = PaintUIBarButtonItems.undoButton
        self.redoButton = PaintUIBarButtonItems.redoButton
        
        self.blackColorButton = PaintUIBarButtonItems.blackColorButton
        self.blueColorButton = PaintUIBarButtonItems.blueColorButton
        self.greenColorButton = PaintUIBarButtonItems.greenColorButton
        self.yellowColorButton = PaintUIBarButtonItems.yellowColorButton
        self.redColorButton = PaintUIBarButtonItems.redColorButton
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        self.navigationItem.leftBarButtonItem = self.clearButton
        self.navigationItem.rightBarButtonItem = self.saveButton
        
        self.view = self.paintView
        self.edgesForExtendedLayout = []
        
        let barColor = UIColor(named: "color_wheat")
        let itemColor = UIColor(named: "color_brown")
        
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.tintColor = itemColor
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.toolbar.barTintColor = barColor
        self.navigationController?.toolbar.tintColor = itemColor
        self.toolbarItems = [
            self.undoButton,
            self.redoButton,
            PaintUIBarButtonItems.flexibleSpace,
            self.blackColorButton,
            self.blueColorButton,
            self.greenColorButton,
            self.yellowColorButton,
            self.redColorButton
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Bindings
        // MARK: - Inputs
        self.paintView.rx.didComplete
            .asSignal()
            .emit(to: self.viewModel.paintPathState.inputs.paintPathDidComplete)
            .disposed(by: disposeBag)
        
        self.undoButton.rx.tap
            .asSignal()
            .emit(to: self.viewModel.paintPathEditState.inputs.undoButtonTapped)
            .disposed(by: disposeBag)
        
        self.redoButton.rx.tap
            .asSignal()
            .emit(to: self.viewModel.paintPathEditState.inputs.redoButtonTapped)
            .disposed(by: disposeBag)
        
        self.clearButton.rx.tap
            .asSignal()
            .emit(to: self.viewModel.paintPathEditState.inputs.clearButtonTapped)
            .disposed(by: disposeBag)
        
        self.blackColorButton.rx.tap
            .asSignal()
            .map { _ in PaintColorType.black }
            .emit(to: self.viewModel.paintPathColorState.inputs.changeColorButtonTapped)
            .disposed(by: disposeBag)
        
        self.blueColorButton.rx.tap
            .asSignal()
            .map { _ in PaintColorType.blue }
            .emit(to: self.viewModel.paintPathColorState.inputs.changeColorButtonTapped)
            .disposed(by: disposeBag)
        
        self.greenColorButton.rx.tap
            .asSignal()
            .map { _ in PaintColorType.green }
            .emit(to: self.viewModel.paintPathColorState.inputs.changeColorButtonTapped)
            .disposed(by: disposeBag)
        
        self.yellowColorButton.rx.tap
            .asSignal()
            .map { _ in PaintColorType.yellow }
            .emit(to: self.viewModel.paintPathColorState.inputs.changeColorButtonTapped)
            .disposed(by: disposeBag)
        
        self.redColorButton.rx.tap
            .asSignal()
            .map { _ in PaintColorType.red }
            .emit(to: self.viewModel.paintPathColorState.inputs.changeColorButtonTapped)
            .disposed(by: disposeBag)
        
        self.saveButton.rx.tap
            .asSignal()
            .emit(to: self.viewModel.paintSaveState.inputs.saveButtonTapped)
            .disposed(by: disposeBag)
        
        // MARK: - Outputs
        self.viewModel.paintPathState.outputs.paint
            .drive(onNext: { [weak self] (elements, colorType) in
                if let cgColor = ColorResolver.resolve(colorType)?.cgColor {
                    self?.draw(elements, cgColor: cgColor)
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel.paintPathEditState.outputs.canUndo
            .drive(self.undoButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.viewModel.paintPathEditState.outputs.undo
            .emit(onNext: { [weak self] _ in
                self?.paintLayers.popLast()?.removeFromSuperlayer()
            })
            .disposed(by: disposeBag)
        
        self.viewModel.paintPathEditState.outputs.canRedo
            .drive(self.redoButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.viewModel.paintPathEditState.outputs.redo
            .emit(onNext: { [weak self] (elements, colorType) in
                if let cgColor = ColorResolver.resolve(colorType)?.cgColor {
                    self?.draw(elements, cgColor: cgColor)
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel.paintPathEditState.outputs.clear
            .emit(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                for layer in self.paintLayers { layer.removeFromSuperlayer() }
                self.paintLayers.removeAll()
            })
            .disposed(by: disposeBag)
        
        self.viewModel.paintPathColorState.outputs.color
            .map { ColorResolver.resolve($0)?.cgColor }
            .drive(self.paintView.shapeLayer.rx.strokeColor)
            .disposed(by: disposeBag)
        
        self.viewModel.paintSaveState.outputs.save
            .emit(onNext: { [weak self] _ in
                self?.saveImage()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private Methods
    private func draw(_ elements: [SNPathElement], cgColor: CGColor) {
        let layerCurve = CAShapeLayer()
        
        layerCurve.path = SNPath.path(from: elements)
        layerCurve.lineWidth = 5.0
        layerCurve.fillColor = UIColor.clear.cgColor
        layerCurve.strokeColor = cgColor
        layerCurve.lineCap = "round"
        layerCurve.lineJoin = "round"
        self.paintView.layer.addSublayer(layerCurve)
        paintLayers.append(layerCurve)
    }
    
    private func getImage() -> UIImage? {
        let rect = self.paintView.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        self.paintView.layer.render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func saveImage() {
        guard let shareImage = self.getImage() else { return }
        
        let activityVC = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        
        // Enable:
        // - UIActivityType.saveToCameraRoll
        // - UIActivityType.mail
        // - UIActivityType.airDrop
        let excludedActivityTypes = [
            UIActivityType.postToFacebook,
            UIActivityType.postToTwitter,
            UIActivityType.message,
            UIActivityType.print,
            UIActivityType.copyToPasteboard,
            UIActivityType.assignToContact,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToWeibo,
            UIActivityType.postToTencentWeibo
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        activityVC.popoverPresentationController?.sourceView = self.view
        
        present(activityVC, animated: true, completion: nil)
    }
}
