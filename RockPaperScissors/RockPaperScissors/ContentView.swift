import SwiftUI

enum Figure: CaseIterable {
    case rock, paper, scissors
    
    var emoji: String {
        switch self {
        case .paper: return "✋"
        case .rock: return "👊"
        case .scissors: return "✌️"
        }
    }
    
    var defeater: Figure {
        switch self {
        case .paper: return .scissors
        case .rock: return .paper
        case .scissors: return .rock
        }
    }
    
    var loser: Figure {
        switch self {
        case .paper: return .rock
        case .rock: return .scissors
        case .scissors: return .paper
        }
    }
}

struct ContentView: View {

    @State private var computerChoice = Figure.allCases.randomElement()!
    @State private var chooseToWin = Bool.random()
    
    @State private var score = 0
    @State private var showingGameOver = false
    @State private var showingScore = false
    @State private var questionNum = 1
    
    @State private var alertTitle = ""
    private let questionNumberPerGame = 10
    
    func showNew() {
        computerChoice = Figure.allCases.randomElement()!
        chooseToWin.toggle()
        questionNum += 1
    }
    
    func chooseAgain() {
        showingGameOver = questionNum == questionNumberPerGame
        
        if !showingGameOver {
            showNew()
        }
    }
    
    func reset() {
        score = 0
        questionNum = 0
        showNew()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(red: 0.65, green: 0.69, blue: 0.88),
                        Color(red: 0.70, green: 0.53, blue: 0.62)]),
                startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text(computerChoice.emoji)
                    .font(.system(size: 120))
                    .padding(.bottom)
                
                Text("Pick one to \(chooseToWin ? "WIN" : "LOSE")")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .foregroundStyle(.ultraThinMaterial)
                
                Spacer()
                
                Section {
                    HStack {
                        ForEach(Figure.allCases, id: \.self) { playerChoice in
                            Button {
                                if playerChoice == (chooseToWin ? computerChoice.defeater : computerChoice.loser) {
                                    score += 1
                                    alertTitle = "Very GOOD!"
                                } else {
                                    score -= 1
                                    alertTitle = "WRONG!"
                                }
                                showingScore = true
                            } label: {
                                Text(playerChoice.emoji)
                                    .font(.system(size: 100))
                            }
                            .labelStyle(.titleAndIcon)
                            .shadow(radius: 5)
                        }
                    }
                    .padding(.all)
                }
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .foregroundStyle(.ultraThinMaterial)
                
                Spacer()
            }
            .alert(alertTitle, isPresented: $showingScore) {
                Button("Continue", action: chooseAgain)
            } message: {
                Text("Your score is \(score)")
            }
            
            .alert("Game Over!", isPresented: $showingGameOver) {
                Button("Play again!", action: reset)
            } message: {
                Text("After \(questionNumberPerGame) times your score is: \(score)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
