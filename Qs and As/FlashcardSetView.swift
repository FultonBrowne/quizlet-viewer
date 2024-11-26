//
//  FlashcardSetView.swift
//  Qs and As
//
//  Created by Fulton Browne on 11/26/24.
//


import SwiftUI

struct FlashcardSetView: View {
    @ObservedObject var flashcardSet: FlashcardSet

    var body: some View {
        NavigationView {
            
            List {
                Section(header: Text("Modes")) {
                    NavigationLink(destination: FlashcardStudyView(flashcardSet: flashcardSet)) {
                        Text("Study Mode")
                    }
                    NavigationLink(destination: LearnModeView(flashcardSet: flashcardSet)) {
                        Text("Learn Mode")
                    }
                    NavigationLink(destination: TestModeView(flashcardSet: flashcardSet)) {
                        Text("Test Mode")
                    }
                }
                
                Section(header: Text("Flashcards")) {
                    ForEach(flashcardSet.flashcards) { flashcard in
                        NavigationLink(destination: FlashcardDetailView(flashcard: flashcard)) {
                            Text(flashcard.term)
                        }
                    }
                }
            }
        }
        .navigationTitle(flashcardSet.name)
    }
}
