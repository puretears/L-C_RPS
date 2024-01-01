//
//  TouchDetectingView.swift
//  RockPaperScissors
//
//  Created by bx11 on 2023/12/29.
//

import UIKit
import Foundation

import UIKit

class TouchDetectingView: UIView {
  // 可能需要一个方法或闭包来将触摸点数量传递给SwiftUI
  var touchCountChanged: ((Int) -> Void)?

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    updateTouchCount(event)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    updateTouchCount(event)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    updateTouchCount(event)
  }

  private func updateTouchCount(_ event: UIEvent?) {
    let touchCount = event?.allTouches?.count ?? 0
    touchCountChanged?(touchCount)
    // 在这里打印或处理触摸点数量
    print("当前触摸点数量: \(touchCount)")
  }
}

