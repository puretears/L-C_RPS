//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by bx11 on 2023/12/26.
//

import SwiftUI

struct ContentView: View {
  let model = Model.shared
  
  var body: some View {
    if model.currStep == 1 {
      WelcomeView().transition(.move(edge: .leading))
    }
    else if model.currStep == 2 {
      LoadingView()
    }
    else {
      GameView()
    }
  }
}

#Preview {
    ContentView()
}
