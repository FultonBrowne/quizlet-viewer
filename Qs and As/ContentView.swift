//
//  ContentView.swift
//  Qs and As
//
//  Created by Fulton Browne on 11/26/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isImporting = false
    @State private var flashcardSets: [FlashcardSet] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(flashcardSets.indices, id: \.self) { i in
                        NavigationLink(destination: FlashcardSetView(flashcardSet: flashcardSets[i])) {
                            Text(flashcardSets[i].name)
                        }
                        .contextMenu {
                            Button{
                                flashcardSets.remove(at: i)
                                print("test")
                            } label: {
                                Text("Delete")
                            }
                        }
                    }
                }
            .listStyle(SidebarListStyle())
            .navigationTitle("Flashcard Sets")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { isImporting.toggle() }) {
                        Label("Import", systemImage: "square.and.arrow.down")
                    }
                }
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [UTType.plainText],
                allowsMultipleSelection: true,
                onCompletion: handleImport
            )
        }
        .onAppear(perform: loadData)
        .onChange(of: flashcardSets) {
            saveData()
        }
    }
    

    func handleImport(result: Result<[URL], Error>) {
        do {
            let selectedFiles = try result.get()
            print("here") // First 'here'
            for fileURL in selectedFiles {
                print("here") // Second 'here'
                // Start accessing the security-scoped resource
                guard fileURL.startAccessingSecurityScopedResource() else {
                    print("Failed to access security scoped resource at \(fileURL)")
                    continue
                }
                defer { fileURL.stopAccessingSecurityScopedResource() }
                
                do {
                    let content = try String(contentsOf: fileURL)
                    print("here") // Third 'here'
                    let parsedFlashcards = parseTSV(contents: content)
                    let setName = fileURL.deletingPathExtension().lastPathComponent
                    let flashcardSet = FlashcardSet(name: setName, flashcards: parsedFlashcards)
                    flashcardSets.append(flashcardSet)
                } catch {
                    print("Failed to read file at \(fileURL): \(error.localizedDescription)")
                }
            }
        } catch {
            print("Failed to import files: \(error.localizedDescription)")
        }
    }

    func parseTSV(contents: String) -> [Flashcard] {
        var flashcards = [Flashcard]()
        let lines = contents.components(separatedBy: .newlines)
        for line in lines where !line.isEmpty {
            let components = line.components(separatedBy: "\t")
            if components.count >= 2 {
                let term = components[1]
                let definition = components[0]
                let flashcard = Flashcard(term: term, definition: definition)
                flashcards.append(flashcard)
            }
        }
        return flashcards
    }
    
    func getApplicationSupportDirectory() -> URL {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportURL = paths[0].appendingPathComponent(Bundle.main.bundleIdentifier ?? "FlashcardApp")
        return appSupportURL
    }
    
    func createDirectoryIfNeeded(at url: URL) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create directory: \(error.localizedDescription)")
            }
        }
    }
    
    func saveData() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(flashcardSets)
            let directoryURL = getApplicationSupportDirectory()
            createDirectoryIfNeeded(at: directoryURL)
            let fileURL = directoryURL.appendingPathComponent("flashcardSets.json")
            try data.write(to: fileURL)
            print("saved")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    func loadData() {
        let directoryURL = getApplicationSupportDirectory()
        let fileURL = directoryURL.appendingPathComponent("flashcardSets.json")
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            flashcardSets = try decoder.decode([FlashcardSet].self, from: data)
        } catch {
            print("Failed to load data: \(error.localizedDescription)")
        }
    }
}
