//
//  GridType.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/11/24.
//

import Foundation

enum GridType {
    case rectangle
    case wideWidth

    var aspectRatio: CGFloat {
        switch self {
        case .rectangle:
            return 1.0
        case .wideWidth:
            return 1.5
 
        }
    }
}
