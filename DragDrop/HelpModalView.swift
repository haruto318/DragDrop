//
//  HelpModalView.swift
//  DragDrop
//
//  Created by 濱野遥斗 on 2024/02/11.
//


import SwiftUI
import AVKit

struct PlayerViewController: UIViewControllerRepresentable {
    let player: AVPlayer

    init(player: AVPlayer) {
        self.player = player
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.player = player
        controller.videoGravity = .resizeAspectFill
        controller.showsPlaybackControls = false
        player.play() // 自動再生
        return controller
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        // none
    }
}

struct HelpModalView: View {
    let player: AVPlayer

    init() {
        self.player = AVPlayer(url: Bundle.main.url(forResource: "playVideo", withExtension: "mp4")!)
    }

    var body: some View {
        VStack{
            Spacer()
            Text("How to Play")
                .font(.custom("KaiseiOpti-Bold", size: 26.0))
                .foregroundColor(Color(UIColor(hexString: "EA4D4D")))
                .padding(.all, 20)
                .frame(maxWidth: 400)
            HStack(alignment: .center){
                PlayerViewController(player: player)
                    .frame(width: 443/3.5, height: 890/3.5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16).stroke(Color(UIColor(hexString: "484848")), lineWidth: 3)
                    )
                    .edgesIgnoringSafeArea(.all)
                Text("'Drag & Drop' the sushi that matches the question onto the sushi tray!\nGuess which one is correct and try to place it!")
                    .font(.custom("KaiseiOpti-Medium", size: 18.0))
                    .foregroundColor(Color(UIColor(hexString: "484848")))
                    .padding(.all, 20)
                    .fixedSize(horizontal: false, vertical: true) // 修正
                                        .frame(maxWidth: .infinity)
            }.padding(.all, 20)
            Spacer()
        }.background(Color(UIColor(hexString: "F6F5F0")))
    }
}

    

#Preview {
    HelpModalView()
}

