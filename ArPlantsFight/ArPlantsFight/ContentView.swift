//
//  ContentView.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 17.06.24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State var arViewModel: ArViewModel = ArViewModel(width: 9, length: 5)
    
    var body: some View {
        VStack{
            ArView(arViewModel: arViewModel)
            ScrollView(.horizontal){
                HStack{
                    Button(action: {arViewModel.selectedPlant = .BasicPlant}, label: {
                        PlantButton(plantType: .BasicPlant, plant: BasicPlant(), arViewModel: arViewModel)
                    })
                    Button(action: {arViewModel.selectedPlant = .Sunflower}, label: {
                        PlantButton(plantType: .Sunflower, plant: Sunflower(), arViewModel: arViewModel)
                    })
                    Button(action: {arViewModel.selectedPlant = .Walnut}, label: {
                        PlantButton(plantType: .Walnut, plant: Walnut(), arViewModel: arViewModel)
                    })
                }
            }
        }.padding(5)
    }
}

#Preview {
    ContentView()
}
