//
//  TurtleComponent.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 02/07/2023.
//

import SwiftUI
import Foundation

struct TurtleComponent: View {
    @State var turtle: Turtle
    @State var timedOut: Bool = true
    @State var fuelFracture: Float = 1.0
    
    init(turtle: Turtle) {
        self._turtle = State(initialValue: turtle)
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "tortoise.fill")
                    .padding(.trailing, 10)
                VStack(alignment: .leading) {
                    HStack {
                        Text(turtle.label ?? String(describing: turtle.device))
                            .font(.title3)
                        Text("#\(turtle.id)")
                            .font(.subheadline)
                            .foregroundStyle(Color(UIColor.secondaryLabel))
                        Spacer()
                        Circle()
                            .fill(timedOut ? .red : .green)
                            .frame(width: 15, height: 15)
                    }
                    Divider()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Status")
                                .font(.caption2)
                                .foregroundStyle(Color(UIColor.secondaryLabel))
                            Text(turtle.status)
                                .font(.title3)
                                .foregroundStyle(turtle.getStatusColor())
                        }
                    }
                }
            }
            HStack {
                ProgressView(value: $fuelFracture.wrappedValue)
                    .tint($fuelFracture.wrappedValue < 0.25 ? .orange : .green)
                    .background($fuelFracture.wrappedValue == 0 ? .red : Color(UIColor.systemGray4))
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, maxHeight: 5)
            .background(Color(UIColor.systemGray4))
        }
        .listRowBackground(Color("SecondaryBackgroundColor"))
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        .onAppear {
            let level: Float = Float(turtle.fuelLevel ?? 1)
            let limit: Float = Float(turtle.fuelLimit ?? 1)
                                  
            fuelFracture = level/limit
        }
        
    }
}


