//
//  ViewModifiers.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 17/09/2023.
//

import Foundation
import SwiftUI

private struct fillMaxWidth: ViewModifier {
    var alignment: Alignment?
    func body(content: Content) -> some View {
        if let alignment = alignment {
            content.frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)
        } else {
            content.frame(minWidth: 0, maxWidth: .infinity)
        }
        
    }
}

private struct fillMaxHeight: ViewModifier {
    var alignment: Alignment?
    func body(content: Content) -> some View {
        if let alignment = alignment {
            content.frame(minHeight: 0, maxHeight: .infinity, alignment: alignment)
        } else {
            content.frame(minHeight: 0, maxHeight: .infinity)
        }
    }
}

private struct fillMaxSize: ViewModifier {
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
    public func FillMaxWidth(alignment: Alignment? = nil) -> some View {
        modifier(fillMaxWidth(alignment: alignment))
    }
    
    public func FillMaxHeight(alignment: Alignment? = nil) -> some View {
        modifier(fillMaxHeight(alignment: alignment))
    }
    
    public func FillMaxSize(alignment: Alignment? = nil) -> some View {
        modifier(fillMaxSize(alignment: alignment))
    }
}
