//
//  Quiz1.swift
//  DragDrop
//
//  Created by 濱野遥斗 on 2024/02/09.
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

struct pastQuiz: Codable {
  let quizName: String
  let isCorrect: Int
}

struct Q: View {
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
    @State var quizArray: [String] = []
    @State var quizCount = 0
    @State var pastQuizes: [pastQuiz] = []
    
    @State var isCorrect: Bool = false
    @State var isShowMaruBatsu: Bool = false
    
    @State var isCompleted: Bool = false
    @State var isShowResultView: Bool = false

    init() {
        self.csvArray = loadCSV(fileName: "quiz").shuffled()
        _quizArray = State(initialValue: self.csvArray[0].components(separatedBy: ","))
//        pastQuizes.append(quizArray[1])
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
        isCorrect = name == answer ? true : false
        if isCorrect {
            let newPastQuiz = pastQuiz(quizName: answer, isCorrect: 1)
            pastQuizes.append(newPastQuiz)
            print("正解")
        } else {
            let newPastQuiz = pastQuiz(quizName: answer, isCorrect: 0)
            pastQuizes.append(newPastQuiz)
            print("不正解")
        }
        nextQuiz()
    }
    
    func nextQuiz() {
        quizCount += 1
        isShowMaruBatsu = true
        if quizCount < 4 {
            quizArray = csvArray[quizCount].components(separatedBy: ",")
        } else {
//            performSegue(withIdentifier: "toScoreVC", sender: nil)
            print("completed")
            print(pastQuizes)
            isCompleted = true
        }
    }
    
    @State private var isStampVisible = false
        @State private var stampScale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            Text("Q. \(quizCount + 1)")
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
                    
                    if isShowMaruBatsu {
                        if isCorrect {
                            ZStack {
                                if isStampVisible {
                                    Image(decorative: "maru")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 300, height: 300)
                                        .scaleEffect(stampScale)
                                        .opacity(isStampVisible ? 1.0 : 0.0)
                                        .onAppear {
                                            withAnimation(Animation.spring(response: 0.1, dampingFraction: 0.1, blendDuration: 0.0)) {
                                            self.stampScale = 1.5
                                            }
                                            //アニメーション後にスタンプが消えないようにするため、isStampVisibleをtrueに保持する
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                self.stampScale = 1.0
                                            }
                                        }
                                }
                            }.onAppear {
                                isStampVisible = true
                            }
                            
                            Button(action: {
                                isShowMaruBatsu = false
                                selectedPerson = nil
                            }){
                                Text("NEXT")
                            }.fullScreenCover(isPresented: $isCompleted){
                                ResultView(pastQuizes: pastQuizes)
                            }
                        } else {
                            ZStack {
                                if isStampVisible {
                                    Image(decorative: "batsu")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 300, height: 300)
                                        .scaleEffect(stampScale)
                                        .opacity(isStampVisible ? 1.0 : 0.0)
                                        .onAppear {
                                            withAnimation(Animation.spring(response: 0.1, dampingFraction: 0.1, blendDuration: 0.0)) {
                                            self.stampScale = 1.5
                                            }
                                            //アニメーション後にスタンプが消えないようにするため、isStampVisibleをtrueに保持する
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                self.stampScale = 1.0
                                            }
                                        }
                                }
                            }.onAppear {
                                isStampVisible = true
                            }
                            
                            if isCompleted {
                                Button(action: {
                                    isShowResultView = true
                                }){
                                    Text("See Result")
                                }.fullScreenCover(isPresented: $isShowResultView){
                                    ResultView(pastQuizes: pastQuizes)
                                }
                            } else {
                                Button(action: {
                                    isShowMaruBatsu = false
                                    selectedPerson = nil
                                }){
                                    Text("NEXT")
                                }
                            }
                        }
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
                    if !isShowMaruBatsu {
                        VStack {
                            Image(decorative: person.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 60)
                            Text( person.imageName)
                        }
                        .draggable(person) {
                            Image(decorative: person.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 20)
                        }.padding()
                    } else {
                        VStack {
                            Image(decorative: person.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 60)
                            Text( person.imageName)
                        }.padding()
                    }
                }
            }.padding()
        }
    }
}

#Preview {
    ContentView()
}
