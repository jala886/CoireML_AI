//
//  PickerControllerDelegate.swift
//  coding_test
//
//  Created by jianli on 9/11/23.
//

import Foundation
import UIKit
import AVKit

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])  {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        classifier.text = "Analyzing Image..."
        // (1) for video
        if let movieUrl = info[.mediaURL] as? URL {
            // work with the video URL
            print("loading \(movieUrl)")
            analyzeVideo(movieUrl)
            return
        }
        // (2) for image
        guard let rawImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        checkAndShowImage(image: rawImage)
        
    }
    
    private func checkAndShowImage(image rawImage: UIImage) {
        //  UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        //image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = rawImage.scaled(to: CGSize(width: 416, height: 416))
        //let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        // UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        //imageView.image = newImage
        // Core ML
        var result = ""
        guard let model = model, let prediction = try? model.prediction(image: pixelBuffer!, iouThreshold: 0.5, confidenceThreshold: 0.5) else {
            return
        }
        if  prediction.coordinates.count == 0 {
            result = "No man in here."
            showInfo(info: result, image: newImage)
            return
        }
        let coord = convertToArray(from: prediction.coordinates)
        if isCenter(positions: coord) {
            result = "This man in center."
        } else {
            result = "This man not in center."
        }
        showInfo(info: result, image: newImage, coord: coord)
    }
    private func drawRectange(image: UIImage, coord: [Double]?) -> UIImage {
        let imageSize = image.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        if let coord = coord, let context = UIGraphicsGetCurrentContext() {
            
            image.draw(at: CGPoint.zero)
            context.setStrokeColor(UIColor.blue.cgColor)
            context.setLineWidth(3)
            
            
            let w = image.size.width
            let h = image.size.height
            let cx = coord[0]
            let cy = coord[1]
            let cw = coord[2]
            let ch = coord[3]
            
            let nw = Int(cw*w)
            let nh = Int(ch*h)
            let hcw = nw/2
            let hch = nh/2
            let nx = Int(cx*w)-hcw
            let ny = Int(cy*h)-hch
            
            
            print(nx,ny,nw,nh)
            context.move(to: CGPoint(x: nx, y: ny))
            context.addLine(to: CGPoint(x: nx+nw, y: ny))
            context.addLine(to: CGPoint(x: nx+nw, y: ny+nh))
            context.addLine(to: CGPoint(x: nx, y: ny+nh))
            context.addLine(to: CGPoint(x: nx, y: ny))
            context.strokePath()

            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        } else {
            return image
        }
    }
    private func showInfo(info:String, image: UIImage, coord: [Double]? = nil) {
        DispatchQueue.main.async { [self] in
            // imageView.image = image
            imageView.image = drawRectange(image: image, coord: coord)
            classifier.text = info
        }
    }
    private func analyzeVideo(_ url: URL) {
        // guard let url = URL(string: surl) else {return}
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator.init(asset: asset)
        let duration = asset.duration.seconds
        print("video length is \(duration)")
        //let cgImage = try! generator.copyCGImage(at: CMTime (0, 1), actualTime: nil)
        //imageView.image = UIImage(cgImage: cgImage) //firstFrame is UIImage in table cell
        // play at background
        DispatchQueue.global().async { [self] in
            for now in 0..<Int(duration) {
                let time = CMTimeMakeWithSeconds(Float64(now), preferredTimescale: 1000)
                print("vidoe time at: \(time.value/1000)s")
                var actualTime = CMTime.zero
                    if let thumbnail = try? generator.copyCGImage(at: time, actualTime: &actualTime) {
                        let image = UIImage(cgImage: thumbnail)
                        self.checkAndShowImage(image: image)
                    }
                // sleep(1)
            }
        }
    }
}
