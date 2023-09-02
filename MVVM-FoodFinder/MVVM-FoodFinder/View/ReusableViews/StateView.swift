//
//  StateView.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 18/08/23.
//

import SwiftUI

struct StateView<Content: View>: View {
    @Binding var state: ViewState
    @ViewBuilder let content: Content
    
    var body: some View {
        switch state {
        case .loading:
            ProgressView()
        case .ready:
            content
        }
    }
}
