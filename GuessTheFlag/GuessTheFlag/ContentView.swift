import SwiftUI

struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}
 
struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var flagsShowedNumber = 1
    @State private var showingGameOver = false
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var tappedFlagNumber = -1
    
    private var isInitialState: Bool {
        tappedFlagNumber == -1
    }
    
    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ],
                center: .top,
                startRadius: 200,
                endRadius: 700
            )
            .ignoresSafeArea()
                
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                
                            withAnimation {
                                tappedFlagNumber = number
                            }
                        } label: {
                            FlagImage(name: countries[number])
                                .rotation3DEffect(
                                    .degrees(tappedFlagNumber == number ? 360 : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .opacity(isInitialState || tappedFlagNumber == number ? 1.0 : 0.25)
                                .offset(y: isInitialState || tappedFlagNumber == number ? 0 : 400)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Over!", isPresented: $showingGameOver) {
            Button("Play again!", action: reset)
        } message: {
            Text("After 8 flags guessing your score is: \(score)")
        }
    }
    
    func reset () {
        flagsShowedNumber = 0
        score = 0
        askQuestion()
    }
    
    func flagTapped (_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            score -= 1
        }
        showingScore = true
    }
    
    func askQuestion () {
        if flagsShowedNumber == 8 {
            showingGameOver = true
            return
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flagsShowedNumber += 1
        
        setInitialState ()
    }
    
    func setInitialState () {
        tappedFlagNumber = -1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
