//
//  ContentView.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 19/07/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: PlacesViewModel = PlacesViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLocationAuthorized {
                    PlacesListView(viewModel: viewModel)
                } else {
                    AuthorizationNeededView()
                }
            }
            .navigationTitle(StaticViewValues.LocalisableStrings.navigationTitle)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
