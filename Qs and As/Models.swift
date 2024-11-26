//
//  Models.swift
//  Qs and As
//
//  Created by Fulton Browne on 11/26/24.
//

import Foundation
import Combine

class Flashcard: Identifiable, Codable, Equatable {
    var id = UUID()
    var term: String
    var definition: String

    init(term: String, definition: String) {
        self.term = term
        self.definition = definition
    }
    
    // Equatable conformance
    static func == (lhs: Flashcard, rhs: Flashcard) -> Bool {
        return lhs.id == rhs.id
    }
}

class FlashcardSet: Identifiable, ObservableObject, Codable, Equatable {
    var id = UUID()
    var name: String
    @Published var flashcards: [Flashcard]

    init(name: String, flashcards: [Flashcard] = []) {
        self.name = name
        self.flashcards = flashcards
    }

    enum CodingKeys: CodingKey {
        case id, name, flashcards
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        flashcards = try container.decode([Flashcard].self, forKey: .flashcards)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(flashcards, forKey: .flashcards)
    }
    
    static func == (lhs: FlashcardSet, rhs: FlashcardSet) -> Bool {
        return lhs.id == rhs.id
    }
}
