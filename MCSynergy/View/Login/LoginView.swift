//
//  Created by Josian van Efferen on 22/05/2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    let authService: AuthService
    
    @Binding var isLoggedIn: Bool
    @ObservedObject var vm: LoginViewModel
    
    init(isLoggedIn: Binding<Bool>) {
        self.vm = LoginViewModel()
        self._isLoggedIn = isLoggedIn
        self.authService = Container.shared.resolveAuthService()
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            if (!vm.loading) {
                VStack {
                    Spacer()
                    Image("MCS_logo_svg")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 40)
                    Spacer()
                    Spacer()
                    Button(action: vm.signInWithMicrosoft) {
                        HStack {
                            Image("MCS_icon")
                                .resizable()
                                .scaledToFit()
                            Text("Sign in as MCS Player")
                        }
                        .frame(width: 300, height: 20)
                        //.padding(.horizontal, 40)
                        
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                    Spacer().frame(height: 15)
                    Button(action: vm.signInAsAnonymous) {
                        HStack {
                            Text("Continue as Guest")
                        }
                        .frame(width: 300, height: 20)
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.bordered)
                    
                    Spacer().frame(height: 20)
                }
                
                
            } else {
                ProgressView {
                    Text("Logging in...")
                }
                
            }
            Spacer()
            
            
           
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.primaryBackgroundColor)
        
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isLoggedIn = false
        LoginView(isLoggedIn: $isLoggedIn)
    }
}
