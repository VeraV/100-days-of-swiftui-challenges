import SwiftUI

enum Figure: CaseIterable {
    case rock, paper, scissors
    
    var name: String {
        switch self{
        case .paper: return "paper"
        case .rock: return "rock"
        case .scissors: return "scissors"
        }
    }
    
    var picture: String {
        switch self {
        case .scissors: return "chevron.up"
        case .rock: return "circle.fill"
        case .paper: return "rectangle.portrait"
        }
    }
    
    var emoji: String {
        switch self {
        case .paper: return "✋"
        case .scissors: return "✌️"
        case .rock: return "👊"
        }
    }
    
    var win: Figure {
        switch self {
        case .rock: return .paper
        case .paper: return .scissors
        case .scissors: return .rock
        }
    }
    
    var lose: Figure {
        switch self {
        case .scissors: return .paper
        case .paper: return .rock
        case .rock: return .scissors
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
    
    func chooseAgain () {
        computerChoice = Figure.allCases.randomElement()!
        chooseToWin.toggle()
        questionNum += 1
    }
    
    func reset () {
        score = 0
        questionNum = 0
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(computerChoice.emoji)
                .font(.largeTitle)
                .padding(.bottom)

            Text("Choose to \(chooseToWin ? "WIN" : "LOSE")")
                .fontWeight(.semibold)
            Spacer()
            Section {
                HStack {
                    ForEach(Figure.allCases, id: \.self) { playerChoice in
                        Button {
                            if playerChoice == (chooseToWin ? computerChoice.win : computerChoice.lose) {
                                score += 1
                                alertTitle = "Very GOOD!"
                                
                            } else {
                                score -= 1
                                alertTitle = "WRONG!"
                            }
                            showingScore = true
                            showingGameOver = questionNum == 10
                        } label: {
                            Text(playerChoice.emoji)
                                .font(.largeTitle)
                        }
                        .labelStyle(.titleAndIcon)
                        .shadow(radius: 5)
                    }
                }
                .padding(.all)
            } header: {
                Text("Pick one:")
                    .foregroundColor(.blue)
            }
            
            Spacer()
            Text("Score: \(score)")
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
            Text("After 10 times your score is: \(score)")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
