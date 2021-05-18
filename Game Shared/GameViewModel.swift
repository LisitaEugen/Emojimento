//
//  GameViewModel.swift
//  Emojimento
//
//  Created by Lisita Evgheni on 15.05.21.
//

import Foundation

final class GameViewModel: ObservableObject {
    let emojis = ["🐅", "🐆", "🦓", "🦍", "🦧", "🦣", "🐘", "🦛"] //, "🦏", "🐪", "🐫", "🦒", "🦘", "🦬", "🐃", "🐂", "🦙", "🦌"]
    @Published var squares: [Square] = []
    @Published var steps: Int = 0
    @Published var isFinished: Bool = false
    var selectedSquares: [Square] = []
    var matches = 0
    
    init() {
        generateSquares()
    }
    
    func newGame() {
        generateSquares()
        resetGame()
    }
    
    func toggle(_ square: Square) {
        toggleSquare(square)
        addSelected(square)
        checkForMatches()
        checkIfFinished()
        steps += 1
    }
    
    private func resetGame() {
        matches = 0
        steps = 0
        isFinished = false
    }
    
    private func generateSquares() {
        squares.removeAll()
        for emoji in emojis {
            squares.append(Square(emoji: emoji))
            squares.append(Square(emoji: emoji))
        }
        squares.shuffle()
    }
    
    private func checkIfFinished() {
        isFinished = matches == squares.count / 2
    }
    
    private func toggleSquare(_ square: Square) {
        squares = squares.map { sq in
            if sq.id == square.id {
                var modified = sq
                modified.toggle()
                return modified
            } else {
                return sq
            }
        }
    }
    
    private func addSelected(_ square: Square) {
        if selectedSquares.count == 2 {
            selectedSquares.removeAll()
        }
        
        selectedSquares.append(square)
    }
    
    private func checkForMatches() {
        if selectedSquares.count == 2 {
            let square1 = selectedSquares[0]
            let square2 = selectedSquares[1]
            
            if(square1.emoji == square2.emoji) {
                print("It's a match!!!")
                matches += 1
            } else {
                print("Not matching, reseting!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    self.toggleSquare(square1)
                    self.toggleSquare(square2)
                }
            }
            
        }
    }
}

struct Square {
    let id: UUID
    let emoji: String
    var hidden: Bool = false
    
    init(id: UUID = UUID(), emoji: String, hidden: Bool = true) {
        self.id = id
        self.emoji = emoji
        self.hidden = hidden
    }
    
    mutating func toggle() {
        hidden = !hidden
    }
}
