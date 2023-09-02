//
//  StaticViewValues.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 16/08/23.
//

import Foundation

struct StaticViewValues {
    struct LocalisableStrings {
        // Should be localized
        static let greeting = "Hey there :)"
        static let authorizationNeededMessage = "Plese make sure to authorize location services in you phone's settings. We need your location in order to display you the images of your path."
        static let goToSettings = "Go to Settings"
        static let navigationTitle = "Places"
        static let emptyView = "There are no items to display :("
        static let refresh = "Refresh"
    }
    
    struct ViewSpacing {
        
        static let viewSpacing = 15.0
    }
}
