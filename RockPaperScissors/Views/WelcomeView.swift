//
//  WelcomeView.swift
//  RockPaperScissors
//
//  Created by bx11 on 2023/12/26.
//

import SwiftUI
import AVFoundation

var audioPlayer: AVAudioPlayer?

struct WelcomeView: View {
  let model = Model.shared
  
  init() {
    if let audioUrl = Bundle.main.url(forResource: "Start", withExtension: "m4a") {
      do {
        audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        audioPlayer?.prepareToPlay()
      }
      catch {
        fatalError(error.localizedDescription)
      }
    }
  }
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        
        makeTitleView()
          .padding(.top, 10)
        Spacer()
        makeIconView()
        Spacer()
        makeButtonView()
          .padding(.bottom, 10)
        Text("Presented by Lucas and Cayla")
          .font(.footnote)
          .foregroundStyle(Color.orange)
          .italic()
          .padding(.bottom)
      }
    }
    .frame(maxWidth: .infinity)
    .background(
      Image("GameBg-v3")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea()
        .overlay {
          Color.black.opacity(0.5)
        }
    )
    // End of VStack
  }
}

extension WelcomeView {
  func makeTitleView() -> some View {
    Group {
      Text("Welcome to")
        .font(.custom("KnightWarrior", size: 64))
        .fontWeight(.bold)
        .foregroundStyle(.orange)
        .padding(.top, 10)
      
      Text("L&C's RPS game")
        .font(.custom("KnightWarrior", size: 64))
        .fontWeight(.bold)
        .foregroundStyle(.orange)
        .padding(.top, 10)
    }
  }
  
  func makeIconView() -> some View {
    Image("RPSIconV3")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 350, height: 350)
      .clipShape(Circle())
  }
  
  func makeButtonView() -> some View {
    Button(action: {
      audioPlayer?.play()
      withAnimation(.easeInOut(duration: 0.8)) {
        model.currStep = 2
      }

    }, label: {
      Text("Start")
        .font(.custom("KnightWarrior", size: 40
                     ))
        .fontWeight(.bold)
        .padding(.horizontal, 200)
        .padding(.vertical, 10)
        .foregroundStyle(.white)
        .background(
          RoundedRectangle(cornerRadius: 16)
            .fill(Color.orange)
        )
    })
    .padding(.bottom, 32)
  }
}


#Preview {
  WelcomeView()
}
