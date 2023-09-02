//
//  PlaceView.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 16/08/23.
//

import SwiftUI

struct PlaceView: View {
    @ObservedObject var viewModel: PlaceViewModel
    
    init(viewModel: PlaceViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                if let image = viewModel.image {
                    FitWidthImageView(image: image)
                } else {
                    FitWidthImagePlaceholderView()
                }
            }
            
            if let name = viewModel.name {
                Text(name)
            }
            
            if let address = viewModel.address {
                if let mapURL = viewModel.mapURL {
                    Link(destination: mapURL, label: {
                        Text(address)
                    })
                    .foregroundStyle(.blue)
                } else {
                    Text(address)
                }
            }
            
            HStack(alignment: .center) {
                if let rating = viewModel.rating {
                    Text(rating)
                }
                
                if let priceLevel = viewModel.priceLevel {
                    Text(priceLevel)
                }
                
                if let isOpen = viewModel.isOpen {
                    Text(isOpen)
                }
            }
            
        }.task {
            viewModel.fetchImage()
        }
    }
}
