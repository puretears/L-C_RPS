//
//  GameView.swift
//  RockPaperScissors
//
//  Created by bx11 on 2023/12/26.
//

import SwiftUI
import Combine
import AVFoundation

struct GameView: View {
  let model = Model.shared
  
  @State var actionTimer = Timer.publish(every: 0.1, on: .main, in: .common)
  @State var cancelActionTimer: Cancellable? = nil
  
  @State var countDownTimer = Timer.publish(every: 1, on: .main, in: .common)
  @State var cancelCountDownTimer: Cancellable? = nil
  
  @State var countDown = 5
  
  @State var isWin = false
  @State var isLose = false
  @State var isShowDeveloperView = false
  @State var fingerCount = 0
  
  @State var password: String = ""
  @State var isPasswordCorrect: Bool = false
  var body: some View {
    ZStack {
      TouchDetectingViewRepresentable(touchCount: $fingerCount)
      VStack {
        makeScoreView()
          .padding(.bottom, 50)
        Spacer()
        HStack {
          makeUserActionView()
            .padding(.leading, 30)
          Spacer()
          makeComputerActionView()
            .padding(.trailing, 30)
        }
        Spacer()
        makeRPSView()
      }
    }
    .onChange(of: model.user.scores, { (oldValue, newValue) in
      if newValue == 5 {
        isWin = true
        loadAndPlay(file: "YouWin", ext: "mp3")
        model.round = 1
        countDown = 5
      }
    })
    .onChange(of: model.computer.scores, { (oldValue, newValue) in
      if newValue == 5 {
        isLose = true
        loadAndPlay(file: "YouLose", ext: "mp3")
        model.round = 1
        countDown = 5
      }
    })
    .onChange(of: fingerCount, { (oldValue, newValue) in
      if newValue == 5 { isShowDeveloperView = true }
    })
    .onChange(of: model.user.name, { (oldValue, newValue) in
      if newValue != "Cayla" && model.user.avatar == "avatar2" {
        model.user.avatar = "UserAvatar"
      }
    })
    .onChange(of: password, { (_, newValue) in
      if password == "31415" || password == "2580" {
        isPasswordCorrect = true
      }
    })
    .sheet(isPresented: $isShowDeveloperView, content: {
      makeDeveloperModeView()
    })
    .sheet(isPresented: $isWin, content: {
      ZStack(alignment: .topTrailing) {
        Color.clear
        
        Button(action: {
          isWin = false
          model.user.scores = 0
          model.user.action = .unknown
          model.computer.scores = 0
          model.computer.action = .unknown
          model.gameResult = .tie
        }, label: {
          Image(systemName: "xmark")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 26, height: 26)
            .foregroundStyle(Color.white)
            .padding()
            .background(
              Color.orange.clipShape(Circle())
            )
        })
        .padding(.top, 20)
        .padding(.trailing, 20)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        Image("YouWin").resizable().aspectRatio(contentMode: .fill)
      )
    })
    .sheet(isPresented: $isLose, content: {
      ZStack(alignment: .topTrailing) {
        Color.clear
        
        Button(action: {
          isLose = false
          model.user.scores = 0
          model.user.action = .unknown
          model.computer.scores = 0
          model.computer.action = .unknown
          model.gameResult = .tie
        }, label: {
          Image(systemName: "xmark")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 26, height: 26)
            .foregroundStyle(Color.white)
            .padding()
            .background(
              Color.orange.clipShape(Circle())
            )
        })
        .padding(.top, 20)
        .padding(.trailing, 20)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        Image("YouLose").resizable().aspectRatio(contentMode: .fill)
      )
    })
    .background(
      Image("GameBg-v1")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea()
        .overlay {
          Color.black.opacity(0.3).ignoresSafeArea()
        }
    )
  }
}

extension GameView {
  @ViewBuilder
  func makeDeveloperModeView() -> some View {
    if isPasswordCorrect {
      ZStack(alignment: .topTrailing) {
        
        VStack(alignment: .center) {
          
          Text("Welcome to Developer Mode")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.bottom, 30)
          
          VStack(alignment: .leading) {
            Text("Change player name")
              .foregroundStyle(Color.gray)
              .fontWeight(.bold)
            
            TextField("", text: Bindable(model.user).name)
              .padding()
              .overlay {
                RoundedRectangle(cornerRadius: 9).stroke(Color.gray, lineWidth: 1.0)
              }
              .padding(.bottom, 20)
            
            Text("Change your avatar")
              .foregroundStyle(Color.gray)
              .fontWeight(.bold)
            
            Grid {
              GridRow {
                ForEach(1...3, id: \.self) { i in
                  Button(action: {
                    if i == 2 {
                      if model.user.name == "Cayla" {
                        model.user.avatar = "avatar\(i)"
                      }
                    }
                    else {
                      model.user.avatar = "avatar\(i)"
                    }
                  }, label: {
                    Image("avatar\(i)")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 100, height: 100)
                      .clipShape(RoundedRectangle(cornerRadius: 16.0))
                  })
                }
              }
              
              GridRow {
                ForEach(4...6, id: \.self) { i in
                  Button(action: {
                    model.user.avatar = "avatar\(i)"
                  }, label: {
                    Image("avatar\(i)")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 100, height: 100)
                      .clipShape(RoundedRectangle(cornerRadius: 16.0))
                  })
                }
              }
              
              GridRow {
                ForEach(7...9, id: \.self) { i in
                  Button(action: {
                    model.user.avatar = "avatar\(i)"
                  }, label: {
                    Image("avatar\(i)")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 100, height: 100)
                      .clipShape(RoundedRectangle(cornerRadius: 16.0))
                  })
                }
              }
            }
          }
          .frame(maxWidth: 404)
          
          
          
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
        Button(action: {
          isShowDeveloperView = false
          password = ""
          isPasswordCorrect = false
        }, label: {
          Image(systemName: "xmark").fontWeight(.bold).foregroundStyle(Color.black)
        })
        .padding(.top, 20)
        .padding(.trailing, 20)
      }
    }
    else {
      VStack {
        Text("Enter developer password:")
          .foregroundStyle(Color.gray)
          .fontWeight(.bold)
        
        TextField("", text: $password)
          .padding()
          .overlay {
            RoundedRectangle(cornerRadius: 9).stroke(Color.gray, lineWidth: 1.0)
          }
          .padding(.bottom, 20)
      }
    }
    
  }


}

extension GameView {
  func loadAndPlay(file: String, ext: String) {
    if let audioURL = Bundle.main.url(forResource: file, withExtension: ext) {
      do {
        audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
        audioPlayer?.prepareToPlay()
        
        audioPlayer?.play()
      }
      catch{
        fatalError(error.localizedDescription)
      }
    }
  }
  func makeRPSView() -> some View {
    HStack {
      //User
      HStack(spacing: 10) {
        Button(action: {
          model.user.action = .rock
          loadAndPlay(file: "Select", ext: ".m4a")
        }, label: {
          Image("Rock")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60)
            .padding()
            .background(Color.orange)
            .clipShape(Circle())
            .padding(6)
            .overlay {
              Circle()
                .stroke(Color.orange, lineWidth: 3.0)
                .opacity(model.user.action == .rock ? 1 : 0)
            }
        })
        .disabled(model.gameStatus != .userChoice)
        
        Button(action: {
          model.user.action = .paper
          loadAndPlay(file: "Select", ext: ".m4a")
        }, label: {
          Image("Paper")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60)
            .padding()
            .background(Color.orange)
            .clipShape(Circle())
            .padding(6)
            .overlay {
              Circle()
                .stroke(Color.orange, lineWidth: 3.0)
                .opacity(model.user.action == .paper ? 1 : 0)
            }
        })
        .disabled(model.gameStatus != .userChoice)
        
        Button(action: {
          model.user.action = .scissors
          loadAndPlay(file: "Select", ext: ".m4a")
        }, label: {
          Image("Scissor")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60)
            .padding()
            .background(Color.orange)
            .clipShape(Circle())
            .padding(6)
            .overlay {
              Circle()
                .stroke(Color.orange, lineWidth: 3.0)
                .opacity(model.user.action == .scissors ? 1 : 0)
            }
        })
        .disabled(model.gameStatus != .userChoice)
        
      }
      
      Spacer()
      
      makeCenterView()
      
      Spacer()
      
      //Computer
      HStack(spacing: 10) {
        Image("Rock")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 60, height: 60)
          .padding()
          .background(Color.orange)
          .clipShape(Circle())
          .padding(6)
          .overlay {
            Circle()
              .stroke(Color.orange, lineWidth: 3.0)
              .opacity(model.computer.action == .rock ? 1 : 0)
          }
        Image("Paper")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 60, height: 60)
          .padding()
          .background(Color.orange)
          .clipShape(Circle())
          .padding(6)
          .overlay {
            Circle()
              .stroke(Color.orange, lineWidth: 3.0)
              .opacity(model.computer.action == .paper ? 1 : 0)
          }
        Image("Scissor")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 60, height: 60)
          .padding()
          .background(Color.orange)
          .clipShape(Circle())
          .padding(6)
          .overlay {
            Circle()
              .stroke(Color.orange, lineWidth: 3.0)
              .opacity(model.computer.action == .scissors ? 1 : 0)
          }
      }
    }
    .padding(.horizontal)
    .padding(.bottom, 20)
  }
  
  @ViewBuilder
  func makeCenterView() -> some View {
    if model.gameStatus == .userChoice {
      makeUserChoiceView()
    }
    else if model.gameStatus == .computerChoice {
      makeComputerChoiceView()
    }
    else {
      // finished
      makeResultView()
    }
  }
  
  func makeUserChoiceView() -> some View {
    VStack {
      Text("👈🏻 Choose your action")
        .font(.custom("KnightWarrior", size: 30))
        .foregroundStyle(Color.orange)
      
      Button(action: {
        model.gameStatus = .computerChoice
        actionTimer = Timer.publish(every: 0.1, on: .main, in: .common)
        cancelActionTimer = actionTimer.connect()
        
        countDownTimer = Timer.publish(every: 1, on: .main, in: .common)
        cancelCountDownTimer = countDownTimer.connect()
      }, label: {
        Text("Finished")
          .font(.custom("KnightWarrior", size: 30))
          .foregroundStyle(Color.orange)
          .padding(.vertical, 5)
          .padding(.horizontal, 30)
          .overlay {
            RoundedRectangle(cornerRadius: 100)
              .stroke(Color.orange, lineWidth: 4.0)
          }
      })
      .disabled(model.user.action == .unknown)
    }
    
    
  }
  
  func makeComputerChoiceView() -> some View {
    VStack {
      Text("\(countDown)")
        .font(.custom("KnightWarrior", size: 40))
        .foregroundStyle(Color.orange)
        .onReceive(countDownTimer, perform: { _ in
          if countDown > 1 {
            countDown -= 1
          }
          else {
            model.gameResult = model.user.action.isWinner(compareTo: model.computer.action)
            model.gameStatus = .finished
            cancelCountDownTimer?.cancel()
            cancelActionTimer?.cancel()
            updateScores()
          }
        })
      
      Text("Computer deciding 👉🏻")
        .font(.custom("KnightWarrior", size: 30))
        .foregroundStyle(Color.orange)
    }
  }
  func updateScores() {
    switch model.gameResult {
    case .lose:
      model.computer.scores += 1
    case .win:
      model.user.scores += 1
    case .tie:
      model.computer.scores += 1
      model.user.scores += 1
    }
  }
  func makeResultView() -> some View {
    let result: String = {
      switch model.gameResult {
      case .tie:
        return "Tie 🤝🏻"
      case .win:
        return "You win! 😀"
      case .lose:
        return "You lose... 😥"
      }
    }()
    
    return VStack {
      Text(result)
        .font(.custom("KnightWarrior", size: 40))
        .foregroundStyle(Color.orange)
      
      Button(action: {
        model.gameResult = .tie
        model.gameStatus = .userChoice
        countDown = 5
      }, label: {
        Text("New round")
          .font(.custom("KnightWarrior", size: 40))
          .foregroundStyle(Color.orange)
      })
    }
  }
  
  func makeUserActionView() -> some View {
    VStack {
      Image(model.user.avatar)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 128, height: 128)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color.orange, lineWidth: 7)
            .shadow(color: Color.black, radius: 3, x: 2, y: 2)
            .clipShape(
              RoundedRectangle(cornerRadius: 16)
            )
        )
      Text(model.user.name)
        .font(.custom("KnightWarrior", size: 56))
        .foregroundColor(Color.orange)
      Image(model.user.action.getImage())
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 100, height: 100)
        .padding()
        .background(Color.orange)
        .clipShape(Circle())
      
    }
  }
  
  func makeComputerActionView() -> some View {
    VStack {
      Image("ComputerAvatar")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 128, height: 128)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color.orange, lineWidth: 7)
            .shadow(color: Color.black, radius: 3, x: 2, y: 2)
            .clipShape(
              RoundedRectangle(cornerRadius: 16)
            )
        )
      Text("Computer")
        .font(.custom("KnightWarrior", size: 56))
        .foregroundColor(Color.orange)
      Image(model.computer.action.getImage())
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 100, height: 100)
        .padding()
        .background(Color.orange)
        .clipShape(Circle())
        .onReceive(actionTimer, perform: { _ in
          let i = Int.random(in: 0...2)
          
          if i == 0 {
            model.computer.action = .rock
          }
          else if i == 1 {
            model.computer.action = .paper
          }
          else {
            model.computer.action = .scissors
          }
        })
      
    }
  }
  
  func makeScoreView() -> some View {
    HStack {
      HStack {
        ForEach(1...5, id: \.self) { i in
          Image(systemName: i <= model.user.scores ? "trophy.fill" : "trophy")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .font(.largeTitle)
            .frame(width: 52, height: 52)
            .foregroundStyle(Color.yellow)
        }
      }// End of Hstack
      
      Spacer()
      
      HStack {
        ForEach(1...5, id: \.self) { i in
          Image(systemName: i <= model.computer.scores ? "trophy.fill" : "trophy")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .font(.largeTitle)
            .frame(width: 52, height: 52)
            .foregroundStyle(Color.yellow)
        }
      }
    }// End of Hstack
    .padding(.horizontal)
  }
}

#Preview {
  GameView()
}
