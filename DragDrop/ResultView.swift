//
//  ResultView.swift
//  DragDrop
//
//  Created by Haruto Hamano on 2024/02/09.
//

import SwiftUI
import UniformTypeIdentifiers

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        // 不要なスペースや改行があれば除去
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // スキャナーオブジェクトの生成
        let scanner = Scanner(string: hexString)
        
        // 先頭(0番目)が#であれば無視させる
        if (hexString.hasPrefix("#")) {
            scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        }
        
        var color:Int64 = 0
        // 文字列内から16進数を探索し、Int64型で color変数に格納
        scanner.scanHexInt64(&color)
        
        let mask:Int = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}


struct DetailButtonView: View {
    @State var isShowModalView: Bool = false
    @State var selectedQuizIndex: Int = 0
    
    var selectedQuiz: pastQuiz
    var index: Int
    
    var body: some View {
        Button(action: {
            isShowModalView = true
        }) {
            Rectangle()
                .foregroundColor(Color(UIColor(hexString: "F6F5F0")))
                .frame(width: 310, height: 55)
                .border(Color(UIColor(hexString: "B2B2B0")), width: 5)
                .overlay(
                    HStack{
                        Spacer()
                        Text("Q.\(index + 1)")
                            .font(.custom("KaiseiOpti-Medium", size: 24.0))
                            .foregroundColor(Color(UIColor(hexString: "6C6C6A")))
                        Spacer()
                        Text("\(selectedQuiz.quizData[0])")
                            .font(.custom("KaiseiOpti-Medium", size: 24.0))
                            .foregroundColor(Color(UIColor(hexString: "6C6C6A")))
                            .frame(width: 200, height: 55)
                        Spacer()
                    }
                    
                )
        }
        .sheet(isPresented: $isShowModalView, onDismiss : {
            self.isShowModalView = false
            print("Close")
            
        })
        {
            DetailView(quizDetail: selectedQuiz)
        }
    }
}




struct QuizData: Codable{
    var id = UUID()
  let name: String
  let imageName: String

}

let pastQuizes: [pastQuiz] = [
    pastQuiz(isCorrect: 0, quizData: ["Maguro?", "maguro"]),
    pastQuiz(isCorrect: 0, quizData: ["Anago?", "anago"]),
    pastQuiz(isCorrect: 0, quizData: ["Aji?", "aji"]),
    pastQuiz(isCorrect: 1, quizData: ["Ootoro?", "ootoro"])
]


struct ResultView: View {
//    @State var selectedPerson: QuizData?
    
    @State var isShowModalView: Bool = false
    @State var selectedQuizIndex: Int = 0
    @State var isBackHome: Bool = false

    var pastQuizes: [pastQuiz]
    var score: Int // モーダルで表示される遷移先ビューに渡すプロパティ
       
       // 初期化メソッド
    init(pastQuizes: [pastQuiz], score: Int) {
        self.pastQuizes = pastQuizes
        self.score = score
    }
    
    let samplePeople: [QuizData] = [
        .init(name: "maguro", imageName: "maguro"),
        .init(name: "salmon", imageName: "salmon"),
        .init(name: "anago", imageName: "anago"),
        .init(name: "ebi", imageName: "ebi"),
        .init(name: "aji", imageName: "aji"),
        .init(name: "ootoro", imageName: "ootoro"),
      ]
    
    func DetailButtonAction(i: Int){
        self.selectedQuizIndex = i
        print(i)
        self.isShowModalView = true
    }


    
    var body: some View {
        ZStack(alignment: .center){
            Image("QuizBack")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            VStack(spacing: 28) {
                VStack{
                    HStack(alignment: .center){
                        Text("Score")
                            .font(.custom("KaiseiOpti-Medium", size: 30.0))
                            .foregroundColor(Color(UIColor(hexString: "484848")))
                    }
                    Text("\(score) pt") 
                        .font(.custom("KaiseiOpti-Medium", size: 54.0))
                        .foregroundColor(Color(UIColor(hexString: "EA4D4D")))
                }.offset(x: 0, y: 40)
                StageImage()
                    .overlay {
                        HStack{
                            Image(decorative: pastQuizes[0].quizData[1])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 30)
                                .rotationEffect(.degrees(-40))
                                .offset(x: 125, y: 0)
                            Image(decorative: pastQuizes[1].quizData[1])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 30)
                                .rotationEffect(.degrees(-40))
                                .offset(x: 40, y: 0)
                            Image(decorative: pastQuizes[2].quizData[1])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 30)
                                .rotationEffect(.degrees(-40))
                                .offset(x: -40, y: 0)
                            Image(decorative: pastQuizes[3].quizData[1])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 30)
                                .rotationEffect(.degrees(-40))
                                .offset(x: -125, y: 0)
                        }
                        
                    }
                
    
                VStack{
                    ForEach(pastQuizes.indices, id: \.self) { i in
                        DetailButtonView(selectedQuiz: pastQuizes[i], index: i)
                    }
                }
                
                Button(action: {
                    self.isBackHome = true
                }) {
                    Rectangle()
                        .foregroundColor(Color(UIColor(hexString: "F6F5F0")))
                        .frame(width: 220, height: 45)
                        .border(Color(UIColor(hexString: "B2B2B0")), width: 5)
                        .overlay(
                            HStack{
                                Spacer()
                                Text("HOME")
                                    .font(.custom("KaiseiOpti-Bold", size: 20.0))
                                    .foregroundColor(Color(UIColor(hexString: "6C6C6A")))
                                    .frame(width: 200, height: 55)
                                Spacer()
                            }
                        )
                }.fullScreenCover(isPresented: $isBackHome, onDismiss : {
                    self.isBackHome = false
                    
                })
                {
                    ContentView()
                }
                .buttonStyle(MyButtonStyle())
                Spacer()
                
                
                
            }
        }
    }
}
                
#Preview {
    ResultView(pastQuizes: pastQuizes, score: 0)
}
