//
//  TestModeView.swift
//  Qs and As
//
//  Created by Fulton Browne on 11/26/24.
//


import SwiftUI

struct TestModeView: View {
    @ObservedObject var flashcardSet: FlashcardSet
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedOption: String?
    @State private var score = 0
    @State private var showResult = false

    var body: some View {
        VStack {
            if currentQuestionIndex < questions.count {
                let question = questions[currentQuestionIndex]

                Text(question.prompt)
                    .font(.headline)
                    .padding()

                List(question.options, id: \.self) { option in
                    HStack {
                        Text(option)
                        Spacer()
                        if selectedOption == option {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedOption = option
                    }
                }
                .listStyle(PlainListStyle())

                Button("Submit") {
                    submitAnswer()
                }
                .disabled(selectedOption == nil)
                .padding()
            } else {
                Text("No questions available.")
            }
        }
        .onAppear(perform: generateQuestions)
        .alert(isPresented: $showResult) {
            Alert(
                title: Text("Test Completed"),
                message: Text("Your score: \(score)/\(questions.count)"),
                dismissButton: .default(Text("OK")) {
                    currentQuestionIndex = 0
                    score = 0
                    generateQuestions()
                }
            )
        }
        .navigationTitle("Test Mode")
    }

    func generateQuestions() {
        questions = []
        let flashcards = flashcardSet.flashcards.shuffled()
        for flashcard in flashcards {
            let incorrectOptions = flashcardSet.flashcards
                .filter { $0 != flashcard }
                .shuffled()
                .prefix(3)
                .map { $0.definition }
            let options = ([flashcard.definition] + incorrectOptions).shuffled()
            let question = Question(prompt: flashcard.term, options: options, answer: flashcard.definition)
            questions.append(question)
        }
    }

    func submitAnswer() {
        if selectedOption == questions[currentQuestionIndex].answer {
            score += 1
        }
        selectedOption = nil
        currentQuestionIndex += 1
        if currentQuestionIndex >= questions.count {
            showResult = true
        }
    }
}

struct Question {
    var prompt: String
    var options: [String]
    var answer: String
}