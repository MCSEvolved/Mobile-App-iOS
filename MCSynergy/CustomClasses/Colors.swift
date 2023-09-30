//
//  Created by Josian van Efferen on 17/09/2023.
//

import Foundation
import SwiftUI

extension Color {
    public static var primaryBackgroundColor: Color {
        return Color("PrimaryBackgroundColor")
    }
    
    public static var secondaryBackgroundColor: Color {
        return Color("SecondaryBackgroundColor")
    }
    
    public static var secondaryLabel: Color {
        return Color(UIColor.secondaryLabel)
    }
}

extension UIColor {
    public static var primaryBackgroundColor: UIColor {
        return UIColor(named: "PrimaryBackgroundColor")!
    }
    
    public static var secondaryBackgroundColor: UIColor {
        return UIColor(named: "SecondaryBackgroundColor")!
    }
}
