//
//  ContentView.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 17.06.24.
//

import SwiftUI
import RealityKit

struct GameView : View {
    @State var arViewModel: ArViewModel
    var levelNumber: Int
    
    init(levelNumber: Int) {
        self.levelNumber = levelNumber
        let zombieSpawnPattern: [((Double, Int), ZombieTypes)]
        
        switch levelNumber {
        case 1:
            zombieSpawnPattern = [((2,1),ZombieTypes.BucketHeadZombie),((10,3),ZombieTypes.BucketHeadZombie),((20,3),ZombieTypes.BucketHeadZombie),((30,3),ZombieTypes.BucketHeadZombie)]
        case 2:
            zombieSpawnPattern = [((2,1),ZombieTypes.BucketHeadZombie),((5,2),ZombieTypes.BucketHeadZombie), ((15,4),ZombieTypes.BucketHeadZombie), ((15,0),ZombieTypes.BucketHeadZombie), ((10,3),ZombieTypes.BucketHeadZombie),((20,3),ZombieTypes.BucketHeadZombie),((30,3),ZombieTypes.BucketHeadZombie)]
        case 3:
            zombieSpawnPattern = [((2,1),ZombieTypes.BucketHeadZombie),((10,3),ZombieTypes.BucketHeadZombie),((20,3),ZombieTypes.BucketHeadZombie),((30,3),ZombieTypes.BucketHeadZombie)]
        case 4:
            zombieSpawnPattern = [((2,1),ZombieTypes.BucketHeadZombie),((10,3),ZombieTypes.BucketHeadZombie),((20,3),ZombieTypes.BucketHeadZombie),((30,3),ZombieTypes.BucketHeadZombie)]
        default:
            zombieSpawnPattern = [((2,1),ZombieTypes.BucketHeadZombie),((10,3),ZombieTypes.BucketHeadZombie),((20,3),ZombieTypes.BucketHeadZombie),((30,3),ZombieTypes.BucketHeadZombie)]
        }
        
        self.arViewModel = ArViewModel(width: 9, length: 5, zombieSpawnPattern: zombieSpawnPattern)
    }
    
    
    var body: some View {
        VStack{
            ZStack{
                ArView(arViewModel: arViewModel)
                
                if arViewModel.killCounter == arViewModel.zombieSpawnPattern.count {
                    Text("You won!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            arViewModel.endArGame()
                            if getCurrentLevel() < levelNumber {
                                saveCurrentLevel(level: levelNumber)
                            }
                        }
                }else if arViewModel.gameLost {
                    Text("You lost!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            arViewModel.endArGame()
                        }
                }
            }
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
    GameView(levelNumber: 1)
}
