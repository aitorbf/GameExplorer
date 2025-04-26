//
//  Font+Ext.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 25/4/25.
//

import SwiftUI

extension Font {
    
    func toUIFont() -> UIFont {
        let fontName: String
        let textStyle: UIFont.TextStyle
        
        switch self {
        case .largeTitle:
            textStyle = .largeTitle
            fontName = UIFont.preferredFont(forTextStyle: textStyle).fontName
        case .title:
            textStyle = .title1
            fontName = UIFont.preferredFont(forTextStyle: textStyle).fontName
        case .headline:
            textStyle = .headline
            fontName = UIFont.preferredFont(forTextStyle: textStyle).fontName
        case .subheadline:
            textStyle = .subheadline
            fontName = UIFont.preferredFont(forTextStyle: textStyle).fontName
        case .body:
            textStyle = .body
            fontName = UIFont.preferredFont(forTextStyle: textStyle).fontName
        case .callout:
            textStyle = .callout
            fontName = UIFont.preferredFont(forTextStyle: textStyle).fontName
        case .footnote:
            textStyle = .footnote
            fontName = UIFont.preferredFont(forTextStyle: textStyle).fontName
        case .caption:
            textStyle = .caption1
            fontName = UIFont.preferredFont(forTextStyle: textStyle).fontName
        default:
            fontName = UIFont.systemFont(ofSize: UIFont.labelFontSize).fontName
            textStyle = .body
        }
        
        guard let uiFont = UIFont(name: fontName, size: UIFont.preferredFont(forTextStyle: textStyle).pointSize) else {
            return UIFont.systemFont(ofSize: UIFont.labelFontSize)
        }
        
        return uiFont
    }
}
