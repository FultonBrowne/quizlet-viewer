//
//  LearnModeView.swift
//  Qs and As
//
//  Created by Fulton Browne on 11/26/24.
//


import SwiftUI

struct LearnModeView: View {
    @ObservedObject var flashcardSet: FlashcardSet
    @State private var remainingFlashcards: [Flashcard] = []
    @State private var currentFlashcard: Flashcard?
    @State private var showDefinition = false

    var body: some View {
        VStack {
            if let flashcard = currentFlashcard {
                Text(showDefinition ? flashcard.definition : flashcard.term)
                    .font(.largeTitle)
                    .padding()
                    .cardStyle()
                    .onTapGesture {
                        withAnimation {
                            showDefinition.toggle()
                        }
                    }

                HStack {
                    Button("Got it Wrong") {
                        moveToNextFlashcard(correct: false)
                    }
                    .padding()

                    Button("Got it Right") {
                        moveToNextFlashcard(correct: true)
                    }
                    .padding()
                }
            } else {
                Text("You've mastered this set!")
                    .font(.title)
                    .padding()
            }
        }
        .onAppear(perform: startLearning)
        .navigationTitle("Learn Mode")
    }

    func startLearning() {
        remainingFlashcards = flashcardSet.flashcards.shuffled()
        currentFlashcard = remainingFlashcards.popLast()
    }

    func moveToNextFlashcard(correct: Bool) {
        if !correct {
            remainingFlashcards.insert(currentFlashcard!, at: 0)
        }
        currentFlashcard = remainingFlashcards.popLast()
        showDefinition = false
    }
}