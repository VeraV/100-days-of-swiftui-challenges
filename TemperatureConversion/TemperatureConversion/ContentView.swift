//
//  ContentView.swift
//  TemperatureConversion
//
//  Created by Vera Fileyeva on 19/01/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var inputUnit = "K"
    @State private var outputUnit = "°C"
    @State private var inputNumber = 273.15
    
    let absoluteZeroConst = 273.15
    
    private var outputNumber: Double {
        let inputInKelvin: Double
        
        if inputUnit == "°C" {
            inputInKelvin = inputNumber + absoluteZeroConst
        } else if inputUnit == "°F" {
            inputInKelvin = 5 / 9 * (inputNumber - 32) + absoluteZeroConst
        } else {
            inputInKelvin = inputNumber
        }
        
        if outputUnit == "°C" {
            return inputInKelvin - absoluteZeroConst
        } else if outputUnit == "°F" {
            return 1.8 * (inputInKelvin - absoluteZeroConst) + 32
        } else {
            return inputInKelvin
        }
    }
    private let units = ["°C", "°F", "K"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Number to convert", value: $inputNumber, format: .number)
                    Picker("Convert from", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    Picker("Convert to", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    Text(outputNumber, format: .number)
                } header: {
                    Text("Result is")
                }
                
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
