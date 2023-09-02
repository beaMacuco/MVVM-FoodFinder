//
//  Logger+Factory.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 29/08/23.
//

import Foundation
import os

extension Logger {
    static func make(for category: AnyClass) -> Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: String(describing: category))
    }
}
