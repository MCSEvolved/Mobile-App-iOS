//
//  MessageComponent.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import SwiftUI

struct MessageComponent: View {
    var body: some View {
        HStack {
            Circle()
                .fill(.red)
                .frame(width: 30, height: 30)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Computer_Label")
                        .font(.title3)
                    Text("#5")
                        .font(.subheadline)
                        .foregroundStyle(Color(UIColor.secondaryLabel))
                }
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras scelerisque, lorem ornare molestie tempor, turpis mauris consequat nunc, a tincidunt ante magna vitae sem. In id purus eu magna cursus pulvinar. Cras auctor nisi sit amet consectetur vulputate. Sed sem diam, "
                )
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .foregroundStyle(Color(UIColor.secondaryLabel))
            }
            
            Text("17:34")
                .font(.caption)
                .foregroundStyle(Color(UIColor.secondaryLabel))
        }
        .listRowBackground(Color("SecondaryBackgroundColor"))
    }
}


struct MessagesComponent: View {
    @State private var selectedView = "All"
    @State var amountOfMessages: Int = 60
    @State var selectedPage: Int = 1
    private let pageSize: Int = 6
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "PrimaryBackgroundColor")
        UISegmentedControl.appearance().backgroundColor = UIColor(named: "SecondaryBackgroundColor")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }
   
    var body: some View {
        VStack {
            Picker("Choose view", selection: $selectedView) {
                Text("All").tag("All")
                Text("Error").tag("Error")
                Text("Warning").tag("Warning")
                Text("Info").tag("Info")
            }.pickerStyle(SegmentedPickerStyle())
            TabView(selection: $selectedPage) {
                ForEach (1..<((120/6)+1)) { i in
                    MessagesPage(selectedPage: $selectedPage, pageNumber: i, pageSize: pageSize).tag(i)
                        
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .background(Color("PrimaryBackgroundColor"))
        }
        .padding(.top, 20)
        
    }
}

private struct MessagesPage: View {
    @Binding var selectedPage: Int
    let pageNumber: Int
    let pageSize: Int
    
    var body: some View {
        List {
            MessageComponent()
            MessageComponent()
            MessageComponent()
            MessageComponent()
            MessageComponent()
            MessageComponent()
        }
        .scrollContentBackground(.hidden)
        .onChange(of: selectedPage) { page in
            if (page == pageNumber || page == pageNumber + 1 || page == pageNumber - 1) {
                //load messages
            } else {
                //remove messages
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesComponent()
    }
}
