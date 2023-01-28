import SwiftUI

enum TemperatureUnit: CaseIterable {
    case celsius, fahrenheit, kelvin
    
    var text: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        case .kelvin: return "K"
        }
    }
    
    func toKelvin(_ value: Double) -> Double {
        switch self {
        case .celsius: return value + absoluteZeroConst
        case .fahrenheit: return 5 / 9 * (value - 32) + absoluteZeroConst
        case .kelvin: return value
        }
    }
    
    func fromKelvin(_ value: Double) -> Double {
        switch self {
        case .celsius: return value - absoluteZeroConst
        case .fahrenheit: return 1.8 * (value - absoluteZeroConst) + 32
        case .kelvin: return value
        }
    }
}

private let absoluteZeroConst = 273.15

struct ContentView: View {
    @State private var inputUnit: TemperatureUnit = .kelvin
    @State private var outputUnit: TemperatureUnit = .celsius
    @State private var inputNumber = 273.15
    
    private var outputNumber: Double {
        let inputInKelvin: Double = inputUnit.toKelvin(inputNumber)
        return outputUnit.fromKelvin(inputInKelvin)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Number to convert", value: $inputNumber, format: .number)
                    Picker("Convert from", selection: $inputUnit) {
                        ForEach(TemperatureUnit.allCases, id: \.self) {
                            Text($0.text)
                        }
                    }
                }
                
                Section {
                    Picker("Convert to", selection: $outputUnit) {
                        ForEach(TemperatureUnit.allCases, id: \.self) {
                            Text($0.text)
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
