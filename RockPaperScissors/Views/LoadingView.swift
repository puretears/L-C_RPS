//
//  LoadingView.swift
//  RockPaperScissors
//
//  Created by bx11 on 2023/12/26.
//

import SwiftUI
import Combine

struct LoadingView: View {
  @State var timeElapsed = 0.0
  @State var timer = Timer.publish(every: 0.1, on: .main, in: .common)
  @State var cancellable: Cancellable? = nil
  
  @State var numberOfDots = 0
  @State var dotTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
  
  let model = Model.shared
  
  var body: some View {
    VStack {
      HStack {
        makeLoadingText()
        makeDotView().opacity(numberOfDots > 0 ? 1 : 0)
        makeDotView().opacity(numberOfDots > 1 ? 1 : 0)
        makeDotView().opacity(numberOfDots > 2 ? 1 : 0)
      }
      makeProgressView()
      //makeButtonView()
    }
    .onAppear{
      DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        cancellable = timer.connect()
      })
    }
    .onReceive(timer, perform: { _ in
      if timeElapsed < 50 {
        timeElapsed += 1
      }
      else {
        cancellable?.cancel()
        model.currStep = 3
      }
    })
    .onReceive(dotTimer, perform: { _ in
      if numberOfDots == 3 {
        numberOfDots = 0
      }
      else {
        numberOfDots += 1
      }
    })
  }
}

extension LoadingView {
  func makeLoadingText() -> some View {
    Text("Loading")
      .font(.custom("KnightWarrior", size: 128))
      .foregroundStyle(Color.orange)
  }
  func makeDotView() -> some View {
    Text(".")
      .font(.custom("KnightWarrior", size: 128))
      .foregroundStyle(Color.orange)
  }
  func makeButtonView() -> some View {
    Button(action: {
      model.currStep = 3
    }, label: {
      Text("Let's begin")
    })
  }
  func makeProgressView() -> some View {
    ProgressView("", value: timeElapsed, total: 50)
      .frame(maxWidth: 500)
      .progressViewStyle(LinearProgressViewStyle(tint: .orange))
      .scaleEffect(x: 1, y: 4, anchor: .center)
  }
}

#Preview {
    LoadingView()
}
