//
//  FlashcardDetailView.swift
//  Qs and As
//
//  Created by Fulton Browne on 11/26/24.
//


import SwiftUI

struct FlashcardDetailView: View {
    var flashcard: Flashcard
    @State private var showDefinition = false

    var body: some View {
        VStack {
            Text(showDefinition ? flashcard.definition : flashcard.term)
                .font(.largeTitle)
                .padding()
                .cardStyle()
                .onTapGesture {
                    withAnimation {
                        showDefinition.toggle()
                    }
                }
        }
        .navigationTitle("Flashcard")
    }
}