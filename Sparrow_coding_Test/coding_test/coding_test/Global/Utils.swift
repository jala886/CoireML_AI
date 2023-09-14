//
//  Utils.swift
//  coding_test
//
//  Created by jianli on 9/11/23.
//

import Foundation
import UIKit
import CoreML

extension UIImage {
    //将图片缩放成指定尺寸（多余部分自动删除）
    func scaled(to newSize: CGSize) -> UIImage {
        //计算比例
        let aspectWidth  = newSize.width/size.width
        let aspectHeight = newSize.height/size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
         
        //图片绘制区域
        var scaledImageRect = CGRect.zero
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
         
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        return scaledImage!
    }
}


func convertToArray(from mlMultiArray: MLMultiArray) -> [Double] {
    
    // Init our output array
    var array: [Double] = []
    
    // Get length
    let length = mlMultiArray.count
    
    // Set content of multi array to our out put array
    for i in 0...length - 1 {
        array.append(Double(truncating: mlMultiArray[[0,NSNumber(value: i)]]))
    }
    
    return array
}

func isCenter(positions: [Double]) -> Bool {
    print(positions)
    if positions[0]>0.4 && positions[1]<0.7 &&
        positions[2] < 0.8 && positions[3]>0.2{
        return true
    } else {
        return false
    }
}
