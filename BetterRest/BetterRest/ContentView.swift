import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = defaultWakeupTime
    @State private var sleepAmountInHours = 8.0
    @State private var coffeeAmountSelected = 2
    
    private var coffeeAmount: Int {
        coffeeAmountSelected + 1
    }
    
    private var wakeUpTimeInSeconds: Double {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        return Double(hour + minute)
    }
    
    private var bedTime: String {
        var result: String
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let prediction = try model.prediction(
                wake: wakeUpTimeInSeconds,
                estimatedSleep: sleepAmountInHours,
                coffee: Double(coffeeAmount)
            )
            
            let sleepTime: Date = wakeUpTime - prediction.actualSleep
            
            result = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            result = "Sorry, there was a problem calculating your bedtime"
        }
        return result
    }
    
    static let defaultWakeupTime: Date = {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker(
                        "Please enter a time",
                        selection: $wakeUpTime,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                        .font(.headline)
                }
                
                Section {
                    Stepper(
                        "\(sleepAmountInHours.formatted()) hours",
                        value: $sleepAmountInHours,
                        in: 4...12, step: 0.25
                    )
                } header: {
                    Text("Desired amount of sleep")
                        .font(.headline)
                }
                
                Section {
                    Picker("Daily coffee intake", selection: $coffeeAmountSelected) {
                        ForEach(1..<21) {
                            Text($0 == 1 ? "1 cup" : "\($0) cups")
                        }
                    }
                }
                
                Section {
                    Text("Ideal bed time is: \("\n")\(bedTime)")
                        .font(.largeTitle)
                        .frame(height: 200)
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
