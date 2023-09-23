//
//  MessagesListViewModel.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 16/09/2023.
//

import Foundation

class MessagesListViewModel: ObservableObject {
    @Published var messages: [Message] = []
    
    @Published var showError: Bool = false
    @Published var error: Error?
    
    @Published var loadingNextPage: Bool = false
    private let pageSize: Int = 30
    
    private var sources: [MessageSource] = []
    private var sourceIds: [String] = []
    private var types: [MessageType] = [.Info, .Warning, .Error]
    
    private let trackerService: TrackerService = Container.shared.resolveTrackerService()
    
    init(sources: [MessageSource] = [], sourceIds: [String] = []) {
        self.sources = sources
        self.sourceIds = sourceIds
    }
    
    private func showError(error: Error) {
        DispatchQueue.main.async {
            self.showError = true
            self.error = error
        }
    }
    
    public func SetTypes(type: String) {
        switch(type) {
        case "All":
            self.types = [.Info, .Warning, .Error]
        case "Info":
            self.types = [.Info]
        case "Warning":
            self.types = [.Warning]
        case "Error":
            self.types = [.Error]
        case "Debug":
            self.types = [.Debug]
        default:
            self.types = [.Info, .Warning, .Error]
        }
        DispatchQueue.main.async {
            self.messages.removeAll()
        }
        
        Task.init {
            await self.FetchMessages(page: 1)
        }
    }
    
    public func FetchMessages(page: Int, refreshList: Bool = true) async {
        do {
            let messages: [Message] = try await trackerService.GetMessages(page: page, pageSize: self.pageSize, types: self.types, sources: self.sources, sourceIds: self.sourceIds)
            DispatchQueue.main.async {
                if refreshList {
                    self.messages.removeAll()
                }
                self.messages = self.messages + messages
                self.loadingNextPage = false
            }
            
        } catch {
            print(error)
            showError(error: error)
        }
        
    }
    
    public func MessageHasAppeared(index: Int) {
        if (index > self.messages.count - 5 && !loadingNextPage && self.messages.count >= self.pageSize) {
            self.loadingNextPage = true
            print("loading new page")
            Task.init {
                await self.FetchMessages(page: (self.messages.count/self.pageSize) + 1, refreshList: false)
            }
        }
    }
}
