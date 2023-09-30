//
//  Created by Josian van Efferen on 30/09/2023.
//

import Foundation
import SignalRClient
import FirebaseAuth


class SignalRClient {
    static let shared: SignalRClient = SignalRClient()
    
    private var hubConnection: HubConnection?
    
    func configureHubConnection() async {
        do {
            let token = try await AuthService.getToken()
            self.hubConnection = HubConnectionBuilder(url: URL(string: "https://api.mcsynergy.nl/tracker/ws/client")!)
                .withLogging(minLogLevel: .debug)
                .withHttpConnectionOptions(configureHttpOptions: { (httpConnectionOptions) in
                    httpConnectionOptions.accessTokenProvider = { return token }
                })
                .build()
            
        } catch {
            print(error)
        }
        
        guard let hubConnection = hubConnection else {
            return
        }
        
        hubConnection.start()
        
        registerListeners()
    }
    
    private func registerListeners() {
        hubConnection!.on(method: "NewComputer") { (computer: Turtle) in
            NotificationCenter.default.post(name: .newComputer, object: nil, userInfo: ["computer":computer])
        }
        
        hubConnection!.on(method: "NewMessage") { (message: Message) in
            NotificationCenter.default.post(name: .newMessage, object: nil, userInfo: ["message":message])
        }
        
        hubConnection!.on(method: "NewLocation") { (location: Location) in
            NotificationCenter.default.post(name: .newLocation, object: nil, userInfo: ["location":location])
        }
    }
}
