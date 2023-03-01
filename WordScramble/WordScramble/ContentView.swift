import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var scoreText = "Scores:\n"
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("Type your word", text: $newWord)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    
                    Section {
                        ForEach(usedWords, id: \.self) { word in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                            }
                        }
                    }
                }
                .listStyle(.grouped)
                
                Text(scoreText)
                    .foregroundColor(.secondary)
            }
            .navigationTitle(rootWord)
            .navigationBarTitleDisplayMode(.large)
            .onSubmit(addNewWord)//if called anywhere on the view
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Game") { startGame() }
                }
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            showError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            showError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'")
            return
        }
        
        guard isReal(word: answer) else {
            showError(title: "Word not recognised", message: "You can't just make them up, you know!")
            return
        }
        
        guard isGoodEnough(word: answer) else {
            showError(title: "Word is too simple!", message: "You can do better then this. At least 3 letters and can't be a '\(rootWord)'")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame () {
        if rootWord != "" {
            var score = 0
            
            for usedWord in usedWords {
                score += usedWord.count
            }
            scoreText += "\(rootWord): \(score)\n"
        }
        usedWords = []
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        // If file is not found or file is empty (which should never happen) then we can trigger a crash
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isGoodEnough(word: String) -> Bool {
        !(word.count < 3 || (word == rootWord))
    }
    
    func showError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
