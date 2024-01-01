//
//  Model.swift
//  RockPaperScissors
//
//  Created by bx11 on 2023/12/26.
//
import SwiftUI
import Foundation

enum GameStatus {
  case userChoice
  case computerChoice
  case finished
}

enum GameResult {
  case win
  case lose
  case tie
}

enum Action {
  case rock
  case paper
  case scissors
  case unknown
  
  func isWinner(compareTo action: Action) -> GameResult {
    if self == .unknown { return .lose }
    
    if self == .rock {
      if action == .rock { return .tie }
      else if action == .paper { return .lose }
      else { return .win}
    }
    else if self == .paper {
      if action == .paper { return .tie }
      else if action == .scissors { return .lose }
      else { return .win}
    }
    else {
      if action == .scissors { return .tie }
      else if action == .rock { return .lose }
      else { return .win}
    }
  }
  func getImage() -> String {
    switch self {
    case .rock:
      return "Rock"
    case .paper:
      return "Paper"
    case .scissors:
      return "Scissor"
    case .unknown:
      return "Unknown"
    }
  }
}

@Observable
final class Model {
  var user = Role(avatar: "UserAvatar", name: "Lucas", scores: 0, action: .unknown)
  var computer = Role(avatar: "ComputerAvatar", name: "Computer", scores: 0, action: .unknown)
  
  static var shared = Model()
  
  // 1 - Welcome
  // 2 - Loading
  // 3 - Game
  var currStep = 1
  var round = 1
  
  var gameStatus = GameStatus.userChoice
  var gameResult = GameResult.tie
}

@Observable
final class Role {
  var avatar: String
  var name: String
  var scores: Int
  var action: Action
  
  init(avatar: String, name: String, scores: Int, action: Action) {
    self.avatar = avatar
    self.name = name
    self.scores = scores
    self.action = action
  }
}
