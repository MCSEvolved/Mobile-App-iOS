//
//  HomeView.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 22/05/2023.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    init() {
    }
    
    
    var body: some View {
        VStack() {
            Text(Auth.auth().currentUser?.displayName ?? "Guest")
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
