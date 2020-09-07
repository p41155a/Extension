//
//  UIImageExtension.swift
//  Extension
//
//  Created by Yoojin Park on 2020/09/07.
//  Copyright © 2020 Yoojin Park. All rights reserved.
//
import UIKit

extension UIImage {
    
    // 세로 이미지 회전 문제로 인한 함수
    func fixOrientation() -> UIImage {
        if (self.imageOrientation == .up) {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)

        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return normalizedImage
    }
}
