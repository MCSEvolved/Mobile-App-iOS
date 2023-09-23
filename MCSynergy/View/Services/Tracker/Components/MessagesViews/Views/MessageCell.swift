//
//  MessageCell.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 17/09/2023.
//

import SwiftUI

struct MessageCell: View {
    let message: Message
    @Binding var detailMessage: Message?
    //@State var displayName: String
    private let trackerService: TrackerService = Container.shared.resolveTrackerService()
    
//    init(message: Message) {
//        self.message = message
//        //self._displayName = State(initialValue: message.source.rawValue)
//    }
    
    
    var body: some View {
        HStack {
            Circle()
                .fill(message.getStatusColor())
                .frame(width: 20, height: 20)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("\(message.getDisplayName())")
                        .font(.title3)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text("#\(message.sourceId)")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryLabel)
                }
                Text(message.content)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .foregroundStyle(Color.secondaryLabel)
            }
            Spacer()
            VStack {
                Text("\(message.getTimeString())")
                    .font(.caption)
                    .foregroundStyle(Color.secondaryLabel)
                Text("\(message.getDateString())")
                    .font(.caption)
                    .foregroundStyle(Color.secondaryLabel)
            }
            
        }
        .padding(10)
//        .task {
//            do {
//                self.displayName = try await trackerService.GetDisplayName(source: message.source, sourceId: message.sourceId)
//            } catch {
//                print(String(describing: error))
//            }
//      }
        .contentShape(Rectangle())
        .onTapGesture {
            self.detailMessage = message
        }
        Divider()
    }
}
