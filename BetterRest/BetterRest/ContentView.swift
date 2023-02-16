import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeupTime
    @State private var sleepAmomut = 8.0
    @State private var coffeeAmountChecked = 2
    
    private var coffeeAmount: Int {
        return coffeeAmountChecked + 1
    }
    
    private var bedTime: String {
        var result: String
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmomut, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep //result is Date
            
            result = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            result = "Sorry, there was a problem calculating your bedtime"
        }
        return result
    }
    
    static var defaultWakeupTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                        .font(.headline)
                }
                
                Section {
                    Stepper("\(sleepAmomut.formatted()) hours", value: $sleepAmomut, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                        .font(.headline)
                }
                
                Section {
                    Picker("Daily coffee intake", selection: $coffeeAmountChecked) {
                        ForEach(1..<21) {
                            Text($0 == 1 ? "1 cup" : "\($0) cups")
                        }
                    }
                }
                
                VStack {
                    Text("Ideal bed time is: \("\n")\(bedTime)")
                        .font(.largeTitle)
                        .frame(width: .infinity, height: 200, alignment: .center)
                        .multilineTextAlignment(.leading)
                }
                
            }
            .navigationTitle("Better Rest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
