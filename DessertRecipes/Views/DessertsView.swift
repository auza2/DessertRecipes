//
//  DessertsView.swift
//  DessertRecipes
//
//  Created by Jamie Auza on 4/3/24.
//

import SwiftUI
import SwiftData

struct DessertsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var desserts: [Dessert]
    
    var favorites: [Dessert] {
            get {
                return desserts.filter{$0.isFavorite == true}
            }
        }
    var otherDesserts: [Dessert] {
            get {
                return desserts.filter{$0.isFavorite == false}
            }
        }
    
    init(searchString: String = "", sortOrder: [SortDescriptor<Dessert>] = []) {
        _desserts = Query(filter: #Predicate { dessert in
            if searchString.isEmpty {
                true
            } else {
                dessert.name.localizedStandardContains(searchString)
            }
        }, sort: [SortDescriptor(\Dessert.name)])
    }
    
    var body: some View {
        List {
            Section("Favorites") {
                ForEach(favorites) { dessert in
                    VStack{
                        NavigationLink(destination: RecipeDetailView(dessert: dessert)) {
                            DessertListCell(dessert: dessert)
                            
                        }
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                        return 0
                    }
                }
            }
            Section("Other Desserts") {
                ForEach(otherDesserts) { dessert in
                    VStack{
                        NavigationLink(destination: RecipeDetailView(dessert: dessert)) {
                            DessertListCell(dessert: dessert)
                            
                        }
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                        return 0
                    }
                }
            }
        }.onAppear{
            let paths = Bundle.main.paths(forResourcesOfType: "txt", inDirectory: nil)
            decodeMessage(messageFilePath: paths.first!)
        }
    }
    
    struct Node: CustomStringConvertible {
        var wordIndex: Int
        var word: String
        
        init(wordIndex: Int, word: String) {
            self.wordIndex = wordIndex
            self.word = word
        }
        
        var description: String {
            let string = "\(wordIndex) \(word)"
            return string
        }
    }
    
    func decodeMessage(messageFilePath: String) {
        guard let nodeArray = getNodesFromTextFile(textFilePath: messageFilePath) else { return }
        
        var index = 0
        var customDifference = 2
        var decodedSentenceNodesArray: [Node] = []
        
        while( index < nodeArray.count - 1 ) {
            decodedSentenceNodesArray.append(nodeArray[index])
            
            index = index + customDifference
            customDifference = customDifference + 1
        }
        
        print(decodedSentenceNodesArray)
        
        let decodedString = decodedSentenceNodesArray.reduce("") { partialResult, node in
            return "\(partialResult) \(node.word)"
        }
        
        print(decodedString)
    }
    
    func getNodesFromTextFile(textFilePath: String) -> [Node]? {
        do {
            let fileString = try String(contentsOfFile: textFilePath, encoding: String.Encoding.utf8)
            let entriesStrings = fileString.components(separatedBy: "\r\n")
            
            var nodeArray: [Node] = []
            for entry in entriesStrings {
                let entryComponents = entry.components(separatedBy: " ")
                guard entryComponents.count == 2, let index = Int(entryComponents[0]), !entryComponents[1].isEmpty else {
                    break
                }

                let node = Node(wordIndex: index, word: entryComponents[1])
                nodeArray.append(node)
            }
            
            nodeArray.sort(by: {$0.wordIndex < $1.wordIndex})
            return nodeArray
        } catch {
            print("Error: Text file does not exists")
            return nil
        }
    }
}

