//
//  BindableViewModel.swift
//  SampleWLSwiftNetworking
//
//  Created by Antoine Gamond on 22/02/2016.
//  Copyright © 2016 Worldline. All rights reserved.
//

import Foundation
import RxSwift

public protocol BindableViewModel: class {

    associatedtype ViewModel

    var viewModel: ViewModel? { get set }
    var disposeBag: DisposeBag { get }

    func bindViewModel(viewModel: ViewModel)
}

public extension BindableViewModel where Self: AnyObject {

    var viewModel: ViewModel? {

        get {
            return associatedObject(self, key: &AssociatedObjectKey.ViewModel)
        }
        set(newViewModel) {
            if let viewModel = newViewModel {
                associateObject(self, key: &AssociatedObjectKey.ViewModel, value: viewModel)
            }
        }
    }

    var disposeBag: DisposeBag {

        get {
            return associatedObject(self, key: &AssociatedObjectKey.DisposeBag) {
                return DisposeBag()
            }
        }
        set {
            associateObject(self, key: &AssociatedObjectKey.DisposeBag, value: newValue)
        }
    }
}

public extension BindableViewModel {

    /**
     Convenience method to unwrap the optional viewModel. This method calls `bindViewModel(viewModel: ViewModel)`.
     */
    func bindViewModel() {

        if let vm = viewModel {
            bindViewModel(vm)
        }
    }
}
