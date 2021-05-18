//
//  ContentView.swift
//  Shared
//
//  Created by Lisita Evgheni on 15.05.21.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        let nb = sqrt(Double(viewModel.squares.count))
        
        VStack {
            HStack {
                Text("Steps:")
                    .ifOS(.watchOS) {
                        $0.font(.subheadline)
                    }
                    .ifOS(.iOS, .tvOS, .macOS) {
                        $0.font(.largeTitle)
                    }
                Text("\(viewModel.steps)")
                    .ifOS(.watchOS) {
                        $0.font(.subheadline)
                    }
                    .ifOS(.iOS, .tvOS, .macOS) {
                        $0.font(.largeTitle)
                    }
            }
            Spacer()
            if viewModel.isFinished {
                VStack {
                    Text("Finished! Your scrore is \(viewModel.steps) from minimum of \(viewModel.squares.count)!")
                        .font(.headline)
                        .padding()
                    Button(action: {
                        viewModel.newGame()
                    }) {
                        Text("New Game?")
                            .ifOS(.watchOS) {
                                $0.font(.subheadline)
                            }
                            .ifOS(.iOS, .tvOS, .macOS) {
                                $0.font(.title)
                            }
                    }
                    .ifOS(.iOS, .tvOS, .macOS) {
                        $0.buttonStyle(CustomButtonStyle())
                    }
                }
            } else {
                GeometryReader { geometry in
                    Group {
                        if #available(tvOS 14.0, iOS 14.0, macOS 11.0, *) {
                            let columns: [GridItem] = Array(repeating: .init(.flexible()), count: Int(nb))
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(viewModel.squares, id: \.id) { square in
                                    Button(action: {
                                        print(square.emoji)
                                        viewModel.toggle(square)
                                    }) {
                                        Text(square.hidden ? "❓" : square.emoji)
                                            .font(.subheadline)
                                            .padding()
                                    }
                                    .buttonStyle(CustomButtonStyle())
                                }
                            }
                        } else {
                            makeiOS13Grid()
                        }
                    }
                    .padding()
                }
            }
            Spacer()
        }}
    
    private func makeiOS13Grid() -> some View {
        let nb = sqrt(Double(viewModel.squares.count))
        
        return VStack(alignment: .leading) {
            ForEach(0..<Int(nb)) { row in
                HStack(alignment: .firstTextBaseline) {
                    ForEach(0..<Int(nb)) { column -> AnyView in
                        let index = row * Int(nb) + column
                        if index < viewModel.squares.count {
                            let square = viewModel.squares[index]
                            return
                                AnyView(Button(action: {
                                    print(square.emoji)
                                    viewModel.toggle(square)
                                }) {
                                    Text(square.hidden ? "❓" : square.emoji)
                                        .font(.title)
                                        .ifOS(.watchOS) {
                                            $0.font(.subheadline)
                                        }
                                        .padding()
                                }
                                .buttonStyle(CustomButtonStyle())
                                )
                        } else {
                            return AnyView(EmptyView())
                        }
                    }
                }
            }
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(Color.white)
            .cornerRadius(4.0)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .ifOS(.iOS, .tvOS, .macOS) {
                $0.padding()
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView().environmentObject(GameViewModel())
    }
}


enum OperatingSystem {
    case macOS
    case iOS
    case tvOS
    case watchOS
    
    #if os(macOS)
    static let current = macOS
    #elseif os(iOS)
    static let current = iOS
    #elseif os(tvOS)
    static let current = tvOS
    #elseif os(watchOS)
    static let current = watchOS
    #else
    #error("Unsupported platform")
    #endif
}

extension View {
    /**
     Conditionally apply modifiers depending on the target operating system.
     
     ```
     struct ContentView: View {
     var body: some View {
     Text("Unicorn")
     .font(.system(size: 10))
     .ifOS(.macOS, .tvOS) {
     $0.font(.system(size: 20))
     }
     }
     }
     ```
     */
    @ViewBuilder
    func ifOS<Content: View>(
        _ operatingSystems: OperatingSystem...,
        modifier: (Self) -> Content
    ) -> some View {
        if operatingSystems.contains(OperatingSystem.current) {
            modifier(self)
        } else {
            self
        }
    }
}
