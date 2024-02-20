//
//  DetailView.swift
//  DragDrop
//
//  Created by 濱野遥斗 on 2024/02/10.
//

import SwiftUI

let sampleData: pastQuiz = pastQuiz(isCorrect: 0, quizData: ["Maguro?", "maguro", "鮪", "”Ebi” is a shrimp which is delightful seafood that you don't want to miss out on. With its firm yet succulent texture and sweet flavor, Ebi offers a taste of the ocean like no other. At our restaurant, we carefully select the finest quality shrimp and prepare them using our unique culinary techniques. Whether enjoyed as nigiri sushi or in our specialty shrimp tempura, Ebi promises a gastronomic experience that will leave you craving for more. Indulge in our exquisite Ebi dishes and embark on a culinary journey like never before."])

struct DetailView: View {

    var quizDetail: pastQuiz
    
//    init(quizDetail: pastQuiz) {
//        self.quizDetail = quizDetail
//        print(quizDetail)
//    }
    

    var body: some View {
        VStack{
            Spacer()
            HStack(alignment: .bottom) {
                Text(quizDetail.quizData[1].prefix(1).uppercased() + quizDetail.quizData[1].dropFirst())
                    .font(.custom("KaiseiOpti-Medium", size: 34.0))
                    .foregroundColor(Color(UIColor(hexString: "484848")))
                Text(quizDetail.quizData[2]) .font(.custom("KaiseiOpti-Medium", size: 28.0))
                    .foregroundColor(Color(UIColor(hexString: "484848")))
            }
            Spacer()
            Image(decorative: quizDetail.quizData[1])
                .resizable()
                .scaledToFill()
                .frame(width: 230, height: 150)
            Spacer()
            Text(quizDetail.quizData[3])
                .font(.custom("KaiseiOpti-Medium", size: 18.0))
                .foregroundColor(Color(UIColor(hexString: "484848")))
                .padding(.all, 20)
            Spacer()
        }.background(Color(UIColor(hexString: "F6F5F0"))).onAppear{
            print(quizDetail)
            }
    }
}

#Preview {
    DetailView(quizDetail: sampleData)
}



