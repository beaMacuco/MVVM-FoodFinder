//
//  Publisher+WeakAssign.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 16/08/23.
//

import Foundation
import Combine

extension Publisher where Failure == Never {
    
    func weakAssign<T: AnyObject>(to keyPath: ReferenceWritableKeyPath<T, Output>, on object: T) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
