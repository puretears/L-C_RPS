//
//  TouchDetectingViewRepresentable.swift
//  RockPaperScissors
//
//  Created by bx11 on 2023/12/29.
//

import SwiftUI

import SwiftUI

struct TouchDetectingViewRepresentable: UIViewRepresentable {
  @Binding var touchCount: Int

  func makeUIView(context: Context) -> TouchDetectingView {
    let view = TouchDetectingView()
    view.touchCountChanged = { count in
      self.touchCount = count
    }
    return view
  }
  
  func updateUIView(_ uiView: TouchDetectingView, context: Context) {
    
  }
}

