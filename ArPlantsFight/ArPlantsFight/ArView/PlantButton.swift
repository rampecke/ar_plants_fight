//
//  PlantButton.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 08.07.24.
//

import SwiftUI

struct PlantButton: View {
    var plantType: PlantTypes
    var plant: Plant
    var arViewModel: ArViewModel
    
    func returnImageName() -> String {
        switch plantType {
        case .Sunflower:
            return "Sunflower"
        case .Walnut:
            return "Walnut"
        case .BasicPlant:
            return "BasicPlant"
        }
    }
    
    func getColor(_ ending: ColorEnding) -> Color {
        if let uiColor = UIColor(named: "\(returnImageName())\(ending.rawValue)") {
            return Color(uiColor)
        } else {
            if ending == .onPrimary {
                return Color.black
            } else {
                return Color.gray
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image(returnImageName())
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading) {
                HStack {
                    Text(returnImageName())
                        .foregroundColor(getColor(.onPrimary))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .background(getColor(.primary))
                .clipShape(
                 .rect(
                     topLeadingRadius: 5,
                     bottomLeadingRadius: 5,
                     bottomTrailingRadius: 5,
                     topTrailingRadius: 5
                 )
                )
                HStack {
                    Group {
                        Text(plant.plantDescription())
                            .padding(3)
                            .foregroundColor(getColor(.onPrimary))
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(Color("contrast_color").opacity(0.5))
                        .cornerRadius(3)
                        .padding(3)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(getColor(.primary))
                    .cornerRadius(5)
            }
        }.padding(5)
        .background(Color("card_background"))
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(arViewModel.selectedPlant == self.plantType ? Color(.red) : Color("card_border"), lineWidth: 1)
        )
        .frame(width: 300, height: 100)
    }
}

#Preview {
    @State var viewModel = ArViewModel(width: 5, length: 5, zombieSpawnPattern: [])
    return Group {
        PlantButton(plantType: .BasicPlant, plant: BasicPlant(), arViewModel: viewModel)
        PlantButton(plantType: .Sunflower, plant: Sunflower(), arViewModel: viewModel)
    }
}

enum ColorEnding: String {
    case onPrimary = "_color_onPrimary"
    case primary = "_color_primary"
}
