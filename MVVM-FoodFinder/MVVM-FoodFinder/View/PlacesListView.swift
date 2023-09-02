//
//  PlacesListView.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 29/07/23.
//

import SwiftUI

struct PlacesListView: View {
    @ObservedObject var viewModel: PlacesViewModel
    
    var body: some View {
        StateView(state: $viewModel.viewState) {
            listOfPlaces
        }
        .task {
            viewModel.setup()
        }
    }
    
    @ViewBuilder
    private var listOfPlaces: some View {
        EmptyHandlerListView(isEmpty: viewModel.viewIsEmpty,
                             shouldRefresh: $viewModel.shouldRefresh) {
            List {
                ForEach(viewModel.places, id:\.id) { place in
                    let viewModel = PlaceViewModel.make(for: place)
                    
                    PlaceView(viewModel: viewModel)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }
}

struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListView(viewModel: PlacesViewModel())
    }
}
