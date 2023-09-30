//
//  Created by Josian van Efferen on 17/09/2023.
//

import Foundation
import SwiftUI

private struct FillMaxWidth: ViewModifier {
    var alignment: Alignment?
    func body(content: Content) -> some View {
        if let alignment = alignment {
            content.frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)
        } else {
            content.frame(minWidth: 0, maxWidth: .infinity)
        }
        
    }
}

private struct FillMaxHeight: ViewModifier {
    var alignment: Alignment?
    func body(content: Content) -> some View {
        if let alignment = alignment {
            content.frame(minHeight: 0, maxHeight: .infinity, alignment: alignment)
        } else {
            content.frame(minHeight: 0, maxHeight: .infinity)
        }
    }
}

private struct FillMaxSize: ViewModifier {
    var alignment: Alignment?
    func body(content: Content) -> some View {
        if let alignment = alignment {
            content.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: alignment)
        } else {
            content.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}

extension View {
    public func fillMaxWidth(alignment: Alignment? = nil) -> some View {
        modifier(FillMaxWidth(alignment: alignment))
    }
    
    public func fillMaxHeight(alignment: Alignment? = nil) -> some View {
        modifier(FillMaxHeight(alignment: alignment))
    }
    
    public func fillMaxSize(alignment: Alignment? = nil) -> some View {
        modifier(FillMaxSize(alignment: alignment))
    }
}
