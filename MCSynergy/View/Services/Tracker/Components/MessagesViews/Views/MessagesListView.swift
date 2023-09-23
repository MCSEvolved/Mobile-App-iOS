//
//  MessageComponent.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import SwiftUI



struct MessagesListView: View {
    @State private var selectedType = "All"
    private let sources: [MessageSource]
    private let sourceIds: [String]
    @State private var liveUpdates: Bool = true
    @State private var detailMessage: Message? = nil
    
    private func setUISegmentedControlAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.primaryBackgroundColor
        UISegmentedControl.appearance().backgroundColor = UIColor.secondaryBackgroundColor
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }
    
    
    @ObservedObject private var vm: MessagesListViewModel
    
    init(sources: [MessageSource] = [], sourceIds: [String] = []) {
        self.sources = sources
        self.sourceIds = sourceIds
        self.vm = MessagesListViewModel(sources: sources, sourceIds: sourceIds)
        setUISegmentedControlAppearance()
    }
   
    var body: some View {
        VStack {
            Picker("Choose Type", selection: $selectedType) {
                Text("All").tag("All")
                Text("Error").tag("Error")
                Text("Warning").tag("Warning")
                Text("Info").tag("Info")
                Text("Debug").tag("Debug")
            }.pickerStyle(SegmentedPickerStyle())
            Spacer().frame(height: 15)
            ScrollView {
                if vm.messages.count == 0 {
                    ProgressView()
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<vm.messages.count, id: \.self) { i in
                            let message: Message = vm.messages[i]
                            MessageCell(message: message, detailMessage: $detailMessage)
                                .onAppear {
                                    vm.MessageHasAppeared(index: i)
                                }
                        }
                        if (vm.loadingNextPage) {
                            ProgressView()
                        }
                    }
                }
            }
            .FillMaxWidth()
            .background(Color.secondaryBackgroundColor)
            .cornerRadius(10)
            .refreshable {
                await self.vm.FetchMessages(page: 1)
            }
        }
        .padding(.top, 20)
        .task {
            await self.vm.FetchMessages(page: 1)
        }
        .onChange(of: selectedType) { type in
            vm.SetTypes(type: type)
        }
        .toolbar {
            Toggle(isOn: $liveUpdates) {
                Image(systemName: liveUpdates ? "wifi" : "wifi.slash")
            }
            .toggleStyle(.button)
        }
        .alert(vm.error?.localizedDescription ?? "Unknown Error", isPresented: $vm.showError) {
            Button("OK") {}
        }
        .sheet(item: $detailMessage) { message in
            MessageDetailView(message: message)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesListView()
    }
}
