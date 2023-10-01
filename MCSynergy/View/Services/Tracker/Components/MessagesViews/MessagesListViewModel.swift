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
    var system: System?
    private var fetchedSystemComputers: Bool = false
    
    private let trackerService: TrackerService = Container.shared.resolveTrackerService()
    
    init(sources: [MessageSource] = [], sourceIds: [String] = [], system: System? = nil) {
        self.sources = sources
        self.sourceIds = sourceIds
        self.system = system
        
        NotificationCenter.default.addObserver(self, selector: #selector(newMessageReceived), name: .newMessage, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .newMessage, object: nil)
    }
    
    private func showError(error: Error) {
        DispatchQueue.main.async {
            self.showError = true
            self.error = error
        }
    }
    
    public func setTypes(type: String) {
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
            await self.fetchMessages(page: 1)
        }
    }
    
    private func getComputerIdsOfSystem() async throws {
        guard let system = system else {
            fetchedSystemComputers = true
            return
        }
        
        if fetchedSystemComputers {
            return
        }
        
        let ids: [Int] = try await trackerService.getTurtleIdsBySystem(systemId: system.id)
        let stringIds: [String] = ids.map { String($0) }
        
        sourceIds += stringIds
        fetchedSystemComputers = true
        

    }
    
    public func fetchMessages(page: Int, refreshList: Bool = true) async {
        do {
            try await getComputerIdsOfSystem()
            let messages: [Message] = try await trackerService.getMessages(page: page, pageSize: self.pageSize, types: self.types, sources: self.sources, sourceIds: self.sourceIds)
            DispatchQueue.main.async {
                if refreshList {
                    self.messages.removeAll()
                }
                self.messages += messages
                self.loadingNextPage = false
            }
            
        } catch {
            print(error)
            showError(error: error)
        }
        
    }
    
    @objc private func newMessageReceived(notification: Notification) {
        let receivedMessage: Message? = notification.userInfo?["message"] as? Message
        
        guard let receivedMessage = receivedMessage else {
            return
        }
        
        if (!fetchedSystemComputers || loadingNextPage) {
            return
        }
        
        if (messageBelongsHere(message: receivedMessage)) {
            DispatchQueue.main.async { [weak self] in
                self?.messages.insert(receivedMessage, at: 0)
                self?.messages.removeLast()
            }
        }
        
        
    }
    
    private func messageBelongsHere(message: Message) -> Bool {
        if !(sources.isEmpty || sources.contains(message.source)) {
            return false
        }
        
        if !(sourceIds.isEmpty || sourceIds.contains(message.sourceId)) {
            return false
        }
        
        if !(types.contains(message.type)) {
            return false
        }
        
        return true
    }
    
    public func messageHasAppeared(index: Int) {
        if (index > self.messages.count - 5 && !loadingNextPage && self.messages.count >= self.pageSize) {
            self.loadingNextPage = true
            print("loading new page")
            Task.init {
                await self.fetchMessages(page: (self.messages.count/self.pageSize) + 1, refreshList: false)
            }
        }
    }
}
