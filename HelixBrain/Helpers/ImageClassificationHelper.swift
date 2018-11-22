//
//  ImageClassificationHelper.swift
//  HelixBrain
//
//  Created by Emmanuel  Ogbewe on 11/22/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import Foundation
import CoreVideo
import UIKit

public class ImageClassificationHelper {
    
    let model = Resnet50()
    
    //This functions takes in an image and converts it to
    // a type CVPixelBuffer
       func pixelBuffr(forImage image: CGImage) -> CVPixelBuffer?{
        let frameSize = CGSize(width: image.width, height: image.height)
        
        var pixelBuffer : CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA, nil, &pixelBuffer)
        if status != kCVReturnSuccess{
            return nil
        }
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height),bitsPerComponent : 8,bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),space: rgbColorSpace,bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    func imageToText(forImage image: UIImage) -> String?{
        if let pixelBuffer = pixelBuffr(forImage: image.cgImage!){
            guard let text = try? model.prediction(image: pixelBuffer)else{
                fatalError("unexpected runtime error")}
            return text.classLabel
        }
        return nil
    }
}
