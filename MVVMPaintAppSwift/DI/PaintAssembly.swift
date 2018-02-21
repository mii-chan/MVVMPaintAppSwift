//
//  PaintAssembly.swift
//  MVVMPaintAppSwift
//
//  Created by Miida Yuki on 2018/02/21.
//  Copyright © 2018年 Miida Yuki. All rights reserved.
//

import Swinject

final class PaintAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PaintPathRepositoryType.self) { _ in PaintPathRepository() }
        
        container.register(PaintPathStateType.self) { r in
            PaintPathState(repository: r.resolve(PaintPathRepositoryType.self)!)
        }
        
        container.register(PaintPathEditStateType.self) { r in
            PaintPathEditState(repository: r.resolve(PaintPathRepositoryType.self)!)
        }
        
        container.register(PaintPathColorStateType.self) { r in
            PaintPathColorState(repository: r.resolve(PaintPathRepositoryType.self)!)
        }
        
        container.register(PaintSaveStateType.self) { r in
            PaintSaveState()
        }
        
        container.register(PaintViewModel.State.self) { r in
            (
                r.resolve(PaintPathStateType.self)!,
                r.resolve(PaintPathEditStateType.self)!,
                r.resolve(PaintPathColorStateType.self)!,
                r.resolve(PaintSaveStateType.self)!
            )
        }
        
        container.register(PaintViewModelType.self) { r in
            PaintViewModel(state: r.resolve(PaintViewModel.State.self)!)
        }
        
        container.register(PaintViewController.self) { r in
            PaintViewController(viewModel: r.resolve(PaintViewModelType.self)!)
        }
    }
}
