import SwiftUI

struct ContentView: View {
    private let startTableNumber = 2
    private let endTableNumber = 12
    private let questionsTotalRange = [5, 10, 20]
    
    @State private var tableNumberIndex = 0
    private var tableNumber: Int {
        tableNumberIndex + startTableNumber
    }
    
    @State private var questionsTotal = 5
    @State private var questionNumber = 0
    @State private var randomMultiplier = 0
    @State private var correctAnswer = 0
    @State private var userAnswer = 0
    
    @State private var showingSettings = true
    @State private var showingScore = false
    @State private var showingGameOver = false
    @FocusState private var answerIsFocused: Bool
    
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if (showingSettings) {
                    Section {
                        Picker("Table to study", selection: $tableNumberIndex) {
                            ForEach(startTableNumber..<endTableNumber + 1) {
                                Text("\($0) times table")
                            }
                        }
                        
                        Picker("Questions to ask", selection: $questionsTotal) {
                            ForEach(questionsTotalRange, id: \.self) {
                                Text("\($0) questions to ask")
                            }
                        }
                    }
                    .transition(.push(from: .top))
                    
                } else {
                    
                    Section {
                        Text("Question number \(questionNumber)")
                            
                        Text("\(tableNumber) * \(randomMultiplier) ?")
                        
                        TextField("Answer is", value: $userAnswer, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($answerIsFocused)
                        
                        Button {
                            answerIsFocused = false
                            checkResult()
                        } label: {
                            Text("Check")
                        }
                    }
                    .transition(.push(from: .bottom))
                }
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text(scoreMessage)
            }
            
            .alert("Game Over", isPresented: $showingGameOver) {
                Button("Start Over", action: reset)
            } message: {
                Text("You did it very well!")
            }
            
            .navigationTitle("FunnyMaths")
            
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        answerIsFocused = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(showingSettings ? "Play!" : "Settings") {
                        withAnimation {
                            showingSettings.toggle()
                        }
                        if showingSettings {
                            reset()
                        } else {
                            askQuestion()
                        }
                    }
                }
            }
            
        }
        
    }
    
    func reset() {
        withAnimation {
            showingSettings = true
            questionNumber = 0
        }
    }
    
    func checkResult() {
        let isCorrect = correctAnswer == userAnswer
        
        if isCorrect {
            scoreTitle = "Correct!"
            scoreMessage = "\(questionsTotal - questionNumber) more questions..."
        } else {
            scoreTitle = "Wrong..."
            scoreMessage = "Correct answer is \(correctAnswer)"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        if questionNumber == questionsTotal {
            showingGameOver = true
            return
        }
        
        userAnswer = 0
        questionNumber += 1
        randomMultiplier = Int.random(in: 1...12)
        correctAnswer = tableNumber * randomMultiplier
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
