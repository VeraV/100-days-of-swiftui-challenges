//
//  ContentView.swift
//  WeSplit
//
//  Created by Vera Fileyeva on 16/01/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPersantage = 20
    @FocusState private var amountIsFocused: Bool
    
    private var currency: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
/*2*/private var amountTotal: Double {
        let checkedPeopleNumber = Double(numberOfPeople + 2)
        let tipChecked = Double(tipPersantage)
        let tipAmount = checkAmount * tipChecked / 100
        return checkAmount + tipAmount
    }
    
    var amountPerPerson: Double {
        let checkedPeopleNumber = Double(numberOfPeople + 2)
        let tipChecked = Double(tipPersantage)
        
        let tipAmount = checkAmount * tipChecked / 100
    /*1*/let amountTotal = checkAmount + tipAmount
        
        let personToPay = amountTotal / checkedPeopleNumber
        return personToPay
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Check Amount", value: $checkAmount, format:
                                currency)
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
                    
                    Picker("Number of People", selection: $numberOfPeople){
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip persantage", selection: $tipPersantage) {
                        ForEach(0..<101, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.wheel)
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(amountTotal, format: currency)
                } header: {
                    Text("Total amount with tip")
                }
                .foregroundColor(tipPersantage == 0 ? .red : .primary)
                
                Section {
                    Text(amountPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                } header: {
                    Text("Amount per person")
                }
            }
            .navigationTitle("WeSplit") //attached to the Form!
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
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
