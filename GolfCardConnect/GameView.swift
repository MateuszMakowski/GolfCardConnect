//
//  ContentView.swift
//  GolfCardConnect
//
//  Created by Mateusz Makowski on 24/11/2023.
//

import SwiftUI

struct GameView: View {
    let numberOfPlayers: Int
    let numberOfHoles: Int
    let playerNames: [String]
    
    @State private var counts: [[Int]]
    @State private var selectedTab = 0
    @State private var visitedTabs: [Int] = []
    @State private var showSummary = false
    
    @State private var pars: [Int] // Par na każdy dołek
    
    init(players: Int, holes: Int, names: [String]) {
        self.numberOfPlayers = players
        self.numberOfHoles = holes
        self.playerNames = names
        self._counts = State(initialValue: Array(repeating: Array(repeating: 1, count: holes), count: players))
        self._pars = State(initialValue: Array(repeating: 3, count: holes)) // Par na każdy dołek ustawiony domyślnie na 3
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 15) {
                    ForEach(visibleTabs(), id: \.self) { index in
                        Button(action: {
                            selectedTab = index
                        }) {
                            Text("Dołek \(index + 1)")
                        }
                        .foregroundColor(index == selectedTab ? .blue : .black)
                    }
                }
                .padding()
                
                Picker("Par", selection: $pars[selectedTab]) {
                    ForEach(3...5, id: \.self) { value in
                        Text("\(value)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
                
                ForEach(0..<numberOfPlayers, id: \.self) { player in
                    CounterView(
                        count: $counts[player][selectedTab],
                        name: playerNames[player]
                    )
                }
                
                if selectedTab < numberOfHoles - 1 {
                    Button(action: {
                        visitedTabs.append(selectedTab)
                        selectedTab = min(selectedTab + 1, numberOfHoles - 1)
                    }) {
                        Text("Następny dołek")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.bottom)
                    }
                } else {
                    NavigationLink(
                        destination: SummaryView(counts: counts, par: pars, names: playerNames),
                        isActive: $showSummary
                    ) {
                        EmptyView()
                    }
                    .isDetailLink(false)
                    
                    Button(action: {
                        showSummary = true
                    }) {
                        Text("Podsumowanie")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.bottom)
                    }
                }
            }
        }.navigationBarBackButtonHidden(true) // Ukrycie przycisku powrotu
            .navigationBarTitle("", displayMode: .inline)
    }
    
    func visibleTabs() -> [Int] {
        var visibleTabs: [Int] = []
        
        if visitedTabs.contains(selectedTab - 1) {
            visibleTabs.append(selectedTab - 1)
        }
        
        visibleTabs.append(selectedTab)
        
        if visitedTabs.contains(selectedTab) {
            visibleTabs.append(selectedTab + 1)
        }
        
        return visibleTabs
    }
}

struct CounterView: View {
    @Binding var count: Int
    var name: String
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 5) { // Zmniejszony margines dla wyniku
                Text("\(name)") // Opis dla wyniku
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, -15) // Zmniejszenie marginesu pod opisem
                HStack {
                    Button(action: {
                        if count > 1 {
                            count -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .imageScale(.large)
                    }
                    .disabled(count <= 1)
                    
                    Text("\(count)")
                    
                    Button(action: {
                        count += 1
                    }) {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                    }
                }
                .font(.title)
                .padding()
            }
            Spacer()
        }
    }
}

struct SummaryView: View {
    @State var counts: [[Int]]
    var par: [Int]
    var names: [String]

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Dołek").font(.system(size: 14))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 4)
                    Text("Par").font(.system(size: 14))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 4)
                    Spacer()
                    ForEach(names.indices, id: \.self) { playerIndex in
                                            Text(names[playerIndex]).font(.system(size: 12))
                                                .frame(maxWidth: .infinity)
                                                .padding(.horizontal, 4)
                                        }
                }
                .padding()
                .background(Color.gray.opacity(0.2))

                ForEach(0..<counts[0].count, id: \.self) { holeIndex in
                    HStack {
                        Text("\(holeIndex + 1)")
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 4)
                        
                        Text("\(par[holeIndex])")
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 4)
                        Spacer()
                        ForEach(0..<counts.count, id: \.self) { playerIndex in
                            
                            
                            TextField("", value: $counts[playerIndex][holeIndex], formatter: NumberFormatter())
                                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                                    .frame(width: 50).padding(.horizontal, 4)
                                                                    .keyboardType(.numberPad)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                }

                HStack {
                    Text("Suma").font(.system(size: 16))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 4)
                    
                    Text("\(par.reduce(0, +))").font(.system(size: 16))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 4)
                    Spacer()
                    ForEach(0..<counts.count, id: \.self) { playerIndex in
                        Text("\(counts[playerIndex].reduce(0, +))").font(.system(size: 16))
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 4)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
            }.navigationBarBackButtonHidden(true) // Ukrycie przycisku powrotu
                        .navigationBarTitle("", displayMode: .inline)
        }
    }
}





