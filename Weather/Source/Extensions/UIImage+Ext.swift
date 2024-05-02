//
//  UIImage+Ext.swift
//  Weather
//
//  Created by jonathan saville on 22/10/2023.
//

import UIKit
import SwiftUI

extension UIImage {

    func getPixelColor(position: CGPoint) -> Color {

        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(self.size.width) * Int(position.y)) + Int(position.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

        return Color(UIColor(red: r, green: g, blue: b, alpha: a))
    }
}
