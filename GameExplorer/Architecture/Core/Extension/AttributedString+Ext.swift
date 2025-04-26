//
//  AttributedString+Ext.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 25/4/25.
//

import SwiftUI

extension AttributedString {
    
    /// Return string size based in its font
    func sizeOfString(usingFont font: Font) -> CGSize {
        let uiFont = font.toUIFont()
        let fontAttributes = [NSAttributedString.Key.font: uiFont]
        let string = NSAttributedString(self).string
        return string.size(withAttributes: fontAttributes)
    }
}
