//
//  View+Extensions.swift
//  Demo
//
//  Created by Brennan Mahoney on 5/27/23.
//

import SwiftUI

extension View{
    // Closing all active keyboards
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    // Disabling w Opacity
    func disableWithOpacity(_ condition: Bool)->some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func hAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    func vAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxHeight: .infinity, alignment: alignment)
        
    }
    // Mark: Custom Border View with Padding
    
    func border(_ width: CGFloat, _ color: Color)->some View{
            self
            .padding(.horizontal, 15)
            .padding(.vertical ,10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    // Mark: Custom Fill View with Padding
    func fillView(_ color: Color)->some View{
            self
            .padding(.horizontal, 15)
            .padding(.vertical ,10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
    
    
}
