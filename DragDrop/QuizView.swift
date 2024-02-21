//
//  ContentView.swift
//  DragDrop
//
//  Created by Haruto Hamano on 2024/02/08.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImageData: Codable, Identifiable {
    var id = UUID()
    let name: String
    let imageName: String

}

extension ImageData: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: ImageData.self, contentType: .image)
    }
}

struct pastQuiz: Codable, Identifiable {
    var id = UUID()
    let isCorrect: Int
    let quizData: [String]
}

let imagesData1: [ImageData] = [
    .init(name: "maguro", imageName: "maguro"),
    .init(name: "salmon", imageName: "salmon"),
    .init(name: "anago", imageName: "anago"),
    .init(name: "ebi", imageName: "ebi"),
    .init(name: "aji", imageName: "aji"),
    .init(name: "ootoro", imageName: "ootoro"),
  ]

struct QuizView: View {
    var level: Int
    let imagesData: [ImageData]
    
    @State var selectedImage: ImageData?
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: 150))]
    
    var csvArray: [String] = []
    @State var quizArray: [String] = []
    @State var quizCount = 0
    @State var count = 1
    @State var pastQuizes: [pastQuiz] = []
    
    @State var isCorrect: Bool = false
    @State var isShowMaruBatsu: Bool = false
    
    @State var isCompleted: Bool = false
    @State var isShowResultView: Bool = false
    
    @State private var isStampVisible = false
    @State private var stampScale: CGFloat = 1.0
    
    @State var score: Int = 0

    init(level: Int, imagesData: [ImageData]) {
        self.level = level
        self.imagesData = imagesData
        
        if self.level == 1 {
            self.csvArray = loadCSV(fileName: "quiz1").shuffled()
        } else if self.level == 2 {
            self.csvArray = loadCSV(fileName: "quiz2").shuffled()
        }
        _quizArray = State(initialValue: self.csvArray[0].components(separatedBy: "!,"))
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
    
    func btnAction(name: String, answer: String, correntQuiz: [String]) {
        print(name)
        print(answer)
        isCorrect = name == answer ? true : false
        if isCorrect {
            let newPastQuiz = pastQuiz(isCorrect: 1, quizData: correntQuiz)
            pastQuizes.append(newPastQuiz)
            score += 1
            print("正解")
        } else {
            let newPastQuiz = pastQuiz(isCorrect: 0, quizData: correntQuiz)
            pastQuizes.append(newPastQuiz)
            print("不正解")
        }
        nextQuiz()
    }
    
    func nextQuiz() {
        quizCount += 1
        isShowMaruBatsu = true
        if quizCount < 4 {
            print("continue")
        } else {
            print("completed")
            isCompleted = true
        }
    }
    
    func apdateText(){
        count += 1
        quizArray = csvArray[quizCount].components(separatedBy: "!,")
    }
    
    var body: some View {
        ZStack(alignment: .center){
            Image("QuizBack")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

            VStack {
                VStack{
                    Text("Q. \(count)")
                        .font(.custom("KaiseiOpti-Medium", size: 30.0))
                        .foregroundColor(Color(UIColor(hexString: "484848")))
                    Text("\(quizArray[0])")
                        .font(.custom("KaiseiOpti-Medium", size: 54.0))
                        .foregroundColor(Color(UIColor(hexString: "484848")))
                }.offset(x: 0, y: 40)
                StageImage()
                    .overlay {
                        if let selectedImage {
                            Image(decorative: selectedImage.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 30)
                        }
                        
                        
                        
                        if isShowMaruBatsu {
                            VStack{
                                ZStack {
                                    if isStampVisible {
                                        Image(decorative: isCorrect ? "maru" : "batsu")
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
                                        NextButton()
                                    }.fullScreenCover(isPresented: $isShowResultView){
                                        ResultView(pastQuizes: pastQuizes, score: score)
                                    }.buttonStyle(MyButtonStyle())
                                } else {
                                    Button(action: {
                                        apdateText()
                                        isShowMaruBatsu = false
                                        selectedImage = nil
                                    }){
                                        NextButton()
                                    }.buttonStyle(MyButtonStyle())
                                }
                            }
                        }
                    }
                    .dropDestination(for: ImageData.self) { images, location in
                        selectedImage = images.first!
                        btnAction(name: selectedImage!.name, answer: quizArray[1], correntQuiz: quizArray)
                        return true
                    }
                Spacer()
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(imagesData) { image in
                        if !isShowMaruBatsu {
                            VStack {
                                DishImage(imageName: image.imageName)
                            }
                            .draggable(image) {
                                Image(decorative: image.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 20)
                            }.padding()
                        } else {
                            VStack {
                                DishImage(imageName: image.imageName)
                            }.padding()
                        }
                    }
                }.padding(.all, 20)
            }
        }
    }
}

#Preview {
    QuizView(level: 1, imagesData: imagesData1)
}





struct NextButton: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color(UIColor(hexString: "F6F5F0")))
            .frame(width: 220, height: 50)
            .border(Color(UIColor(hexString: "B2B2B0")), width: 5)
            .overlay(
                HStack{
                    Spacer()
                    Text("NEXT")
                        .font(.custom("KaiseiOpti-Bold", size: 25.0))
                        .foregroundColor(Color(UIColor(hexString: "6C6C6A")))
                        .frame(width: 200, height: 55)
                    Spacer()
                }
            )
    }
}


struct DishImage: View {
    var imageName: String
    
    var body: some View {
        Image(decorative: "sara")
            .resizable()
            .scaledToFill()
            .frame(width: 110, height: 65).overlay{
                Image(decorative: imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 50)
                    .offset(x: 0, y: -9)
            }
    }
}
