//
//  StartView.swift
//  GolfCardConnect
//
//  Created by Mateusz Makowski on 27/11/2023.
//

import SwiftUI

struct StartScreen: View {
    @State private var numberOfPlayers = 1
    @State private var numberOfHoles = 9
    @State private var playerNames: [String] = ["Gracz 1", "Gracz 2", "Gracz 3", "Gracz 4"]

    var body: some View {
        NavigationView {
            VStack {
                Text("Wybierz ilość graczy:")
                                    .font(.headline)
                                    .padding()
                                Picker("Ilość graczy", selection: $numberOfPlayers) {
                                    ForEach(1..<5, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()

                                ForEach(0..<numberOfPlayers, id: \.self) { index in
                                    TextField("Gracz \(index + 1)", text: Binding(
                                        get: { playerNames[index] },
                                        set: { playerNames[index] = $0 }
                                    ))
                                    .padding()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                
                Text("Wybierz ilość dołków:")
                    .font(.headline)
                    .padding()
                Picker("Ilość dołków", selection: $numberOfHoles) {
                    Text("6").tag(6)
                    Text("9").tag(9)
                    Text("18").tag(18)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
                
                NavigationLink(destination:
                                GameView(players: numberOfPlayers, holes: numberOfHoles, names: playerNames)) {
                    Text("Rozpocznij grę")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    StartScreen()
}
