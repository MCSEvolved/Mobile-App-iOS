//
//  Created by Josian van Efferen on 17/09/2023.
//

import SwiftUI

struct MessageDetailView: View {
    var message: Message
    
    var body: some View {
        VStack {
            Text(message.getDisplayName())
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 10)
            Spacer().frame(height: 50)
            VStack(alignment: .leading, spacing: 5) {
                Text("Message")
                    .foregroundColor(Color.secondaryLabel)
                Text(message.content)
                    .fillMaxWidth(alignment: .leading)
                    .font(.title3)
                    .padding(10)
                    .background(Color.secondaryBackgroundColor)
                    .cornerRadius(15)
            }
            .fillMaxWidth()
            
            Spacer().frame(height: 20)
            
            HStack {
                Spacer()
                
                VStack {
                    Text("Type")
                        .font(.body)
                        .foregroundColor(Color.secondaryLabel)
                    Text(message.type.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(message.getStatusColor())
                }
                .padding(.vertical, 10)
                .padding(.leading, 0)
                
                Spacer()
                Divider().frame(height: 70)
                Spacer()
                
                VStack {
                    Text("Time")
                        .font(.body)
                        .foregroundColor(Color.secondaryLabel)
                    Text("\(message.getTimeString())")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("\(message.getDateString())")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 10)
                
                Spacer()
                Divider().frame(height: 70)
                Spacer()
                
                VStack {
                    Text("Sender")
                        .font(.body)
                        .foregroundColor(Color.secondaryLabel)
                    Text("\(message.source.rawValue)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("\(message.sourceId)")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 10)
                .padding(.trailing, 0)
                
                Spacer()
            }
            .fillMaxWidth(alignment: .leading)
            .background(Color.secondaryBackgroundColor)
            .cornerRadius(15)
            
            
            Spacer()
        }
        .fillMaxSize()
        .padding(10)
        .background(Color.primaryBackgroundColor)
        
    }
}

struct MessageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(message: Message(
            id: "1",
            type: .Error,
            source: .Computer,
            content: "This is a very import error and you should probably do something about it. Lorem Ipsum whatever latin stuff",
            metaData: nil,
            sourceId: "493",
            creationTime: 394019392))
    }
}
