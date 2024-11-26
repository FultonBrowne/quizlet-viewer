//
//  FlashcardStudyView.swift
//  Qs and As
//
//  Created by Fulton Browne on 11/26/24.
//


import SwiftUI

struct FlashcardStudyView: View {
    @ObservedObject var flashcardSet: FlashcardSet
    @State private var currentIndex = 0
    @State private var showDefinition = false

    var body: some View {
        VStack {
            if flashcardSet.flashcards.isEmpty {
                Text("No flashcards available.")
            } else {
                Text(showDefinition ? flashcardSet.flashcards[currentIndex].definition : flashcardSet.flashcards[currentIndex].term)
                    .font(.largeTitle)
                    .padding()
                    .cardStyle()
                    .onTapGesture {
                        withAnimation {
                            showDefinition.toggle()
                        }
                    }

                HStack {
                    Button(action: previousCard) {
                        Text("Previous")
                    }
                    .disabled(currentIndex == 0)

                    Spacer()

                    Button(action: nextCard) {
                        Text("Next")
                    }
                    .disabled(currentIndex == flashcardSet.flashcards.count - 1)
                }
                .padding()
            }
        }
        .navigationTitle("Study Mode")
    }

    func nextCard() {
        if currentIndex < flashcardSet.flashcards.count - 1 {
            currentIndex += 1
            showDefinition = false
        }
    }

    func previousCard() {
        if currentIndex > 0 {
            currentIndex -= 1
            showDefinition = false
        }
    }
}
