//
//  ContentView.swift
//  DragDrop
//
//  Created by 濱野遥斗 on 2024/02/08.
//

import SwiftUI
import UniformTypeIdentifiers

struct Person: Codable, Identifiable {
    var id = UUID()
  let name: String
  let imageName: String

}

extension Person: Transferable {
  static var transferRepresentation: some TransferRepresentation {
    CodableRepresentation(for: Person.self, contentType: .person)
  }
}

extension UTType {
  static var person: UTType { UTType(exportedAs: "com.dragdrop") }
}

struct ContentView: View {
    @State var selectedPerson: Person?
    let samplePeople: [Person] = [
        .init(name: "maguro", imageName: "maguro"),
        .init(name: "salmon", imageName: "salmon"),
        .init(name: "anago", imageName: "anago"),
        .init(name: "ebi", imageName: "ebi"),
        .init(name: "aji", imageName: "aji"),
        .init(name: "ootoro", imageName: "ootoro"),
      ]
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: 150))]
    
    var csvArray: [String] = []
    var quizArray: [String] = []
    @State var quizCount = 0

    init() {
        self.csvArray = loadCSV(fileName: "quiz")
        quizArray = csvArray[quizCount].components(separatedBy: ",")
    }
    
    func loadCSV(fileName: String) -> [String] {
        var csvArray: [String] = []
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
        let csvData = try String(contentsOfFile: csvBundle,encoding: String.Encoding.utf8)
        let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
        csvArray = lineChange.components(separatedBy: "\n")
        csvArray.removeLast()
        } catch {
        print("エラー")
        }
        return csvArray
    }
    
    func btnAction(name: String, answer: String) {
        print(name)
        print(answer)
        if name == answer {
            print("正解")
        } else {
            print("不正解")
        }
    }
    
    var body: some View {
        VStack {
            Text("Q. \(quizCount)")
            Text("\(quizArray[0])")
            Rectangle()
                .foregroundColor(Color.clear)
                .background(
                    Image(decorative: "stage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 100)
                        .offset(x: 0, y: 50)
                )
                .overlay {
                    if let selectedPerson {
                        Image(decorative: selectedPerson.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 30)
                    }
                }
                .dropDestination(for: Person.self) { people, location in
                    selectedPerson = people.first!
                    btnAction(name: selectedPerson!.name, answer: quizArray[1])
                    return true
                }
            Spacer()
            
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(samplePeople) { person in
                    VStack {
                        Image(decorative: person.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 60)
                        Text( person.imageName)
                    }.draggable(person) {
                        Image(decorative: person.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 20)                    }
                }
            }.padding()
        }
    }
}

#Preview {
    ContentView()
}
