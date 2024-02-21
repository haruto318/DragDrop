//
//  ContentView.swift
//  DragDrop
//
//  Created by Haruto Hamano on 2024/02/08.
//

import SwiftUI

struct MyButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .foregroundColor(Color.white)
        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        .opacity(configuration.isPressed ? 0.4 : 1)
    }
}

struct ContentView: View {
    @State var isStart1: Bool = false
    @State var isStart2: Bool = false
    @State var isShowHelpModal: Bool = false
    
    let imagesData1: [ImageData] = [
        .init(name: "maguro", imageName: "maguro"),
        .init(name: "salmon", imageName: "salmon"),
        .init(name: "anago", imageName: "anago"),
        .init(name: "ebi", imageName: "ebi"),
        .init(name: "aji", imageName: "aji"),
        .init(name: "ootoro", imageName: "ootoro"),
      ]
    
    let imagesData2: [ImageData] = [
        .init(name: "ikura", imageName: "ikura"),
        .init(name: "kappamaki", imageName: "kappamaki"),
        .init(name: "negitoro", imageName: "negitoro"),
        .init(name: "oshinkomaki", imageName: "oshinkomaki"),
        .init(name: "tekkamaki", imageName: "tekkamaki"),
        .init(name: "uni", imageName: "uni"),
      ]
    
    var body: some View {
        ZStack(alignment: .center){
            Image("back")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            VStack(spacing: 30) {
                Spacer()
                StageImage()
                    .overlay {
                        HStack{
                            Image(decorative: "ebi")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 30)
                                .rotationEffect(.degrees(-40))
                                .offset(x: 125, y: 0)
                            Image(decorative: "salmon")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 30)
                                .rotationEffect(.degrees(-40))
                                .offset(x: 40, y: 0)
                            Image(decorative: "ikura")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 30)
                                .rotationEffect(.degrees(-40))
                                .offset(x: -40, y: 0)
                            Image(decorative: "tekkamaki")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 30)
                                .rotationEffect(.degrees(-20))
                                .offset(x: -125, y: 0)
                        }
                    }.offset(x: 0, y: 70)
     
                VStack{
                    LevelButton(level: 1, action: { isStart1 = true }, isStart1: $isStart1, isStart2: $isStart2, imagesData1: imagesData1, imagesData2: imagesData2)
                    LevelButton(level: 2, action: { isStart2 = true }, isStart1: $isStart1, isStart2: $isStart2, imagesData1: imagesData1, imagesData2: imagesData2)
                }
                
                
                Button(action: {
                    self.isShowHelpModal = true
                }) {
                    Rectangle()
                        .foregroundColor(Color(UIColor(hexString: "F6F5F0")))
                        .frame(width: 220, height: 45)
                        .border(Color(UIColor(hexString: "B2B2B0")), width: 5)
                        .overlay(
                            HStack{
                                Spacer()
                                Text("How to Play")
                                    .font(.custom("KaiseiOpti-Bold", size: 20.0))
                                    .foregroundColor(Color(UIColor(hexString: "6C6C6A")))
                                    .frame(width: 200, height: 55)
                                Spacer()
                            }
                        )
                }.sheet(isPresented: $isShowHelpModal, onDismiss: {
                    self.isShowHelpModal = false
                }){
                    HelpModalView().presentationDetents([.medium])
                }
                .buttonStyle(MyButtonStyle())
                Spacer()
            }

            
        }
    }
}

struct StageImage: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color.clear)
            .background(
                Image(decorative: "stage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 100)
                    .offset(x: 0, y: 50)
            )
    }
}

struct SushiImage: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color.clear)
            .background(
                Image(decorative: "stage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 100)
                    .offset(x: 0, y: 50)
            )
    }
}

struct LevelButton: View {
    let level: Int
    let action: () -> Void
    @Binding var isStart1: Bool
    @Binding var isStart2: Bool
    let imagesData1: [ImageData]
    let imagesData2: [ImageData]
    
    var body: some View {
        Button(action: action) {
            Rectangle()
                .foregroundColor(Color(UIColor(hexString: "F6F5F0")))
                .frame(width: 310, height: 75)
                .border(Color(UIColor(hexString: "B2B2B0")), width: 5)
                .overlay(
                    HStack{
                        Spacer()
                        Text("Level \(level)")
                            .font(.custom("KaiseiOpti-Bold", size: 35.0))
                            .foregroundColor(Color(UIColor(hexString: "6C6C6A")))
                            .frame(width: 200, height: 55)
                        Spacer()
                    }
                )
        }
        .fullScreenCover(isPresented: level == 1 ? $isStart1 : $isStart2) {
                    QuizView(level: level, imagesData: level == 1 ? imagesData1 : imagesData2)
                }
        .buttonStyle(MyButtonStyle())
    }
}

#Preview {
    ContentView()
}
