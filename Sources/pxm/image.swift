//
//  image.swift
//  
//
//  Created by Fang Ling on 2023/4/16.
//

import Foundation
import CoreGraphics
import AppKit

func png2jpg(png : NSImage) -> NSImage? {
    let cgi = png.cgImage(forProposedRect: nil,
                          context: nil,
                          hints: nil)!
    let bitmapRep = NSBitmapImageRep(cgImage: cgi)
    let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg,
                                            properties: [:])!
    return NSImage(data: jpegData)
}

extension CGImage {
    func resize(width : Int, height : Int) -> CGImage? {
        /// bytes_per_pixel = self.bitsPerPixel / self.bitsPerComponent
        let bytes_per_row = width * bitsPerPixel / bitsPerComponent
        
        guard let color_space = colorSpace else { return nil }
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytes_per_row,
                                      space: color_space,
                                      bitmapInfo: bitmapInfo.rawValue |
                                                  alphaInfo.rawValue) else {
            print("context")
            return nil
        }
        
        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        return context.makeImage()
    }
}

extension NSImage {
    func resize(_ new_size : NSSize) -> NSImage? {
        let frame = NSRect(x: 0,
                           y: 0,
                           width: new_size.width,
                           height: new_size.height)
        guard let rep = self.bestRepresentation(for: frame,
                                                context: nil,
                                                hints: nil) else {
            return nil
        }
        let image = NSImage(size: new_size,
                            flipped: false,
                            drawingHandler: { (_) -> Bool in
            return rep.draw(in: frame)
        })
        
        return image
    }
}

/* https://gist.github.com/john-rocky/c0bcfca3bf5b32a36a01dec716c6c075 */
extension CGImage {
//    func resize(size: CGSize) -> CGImage {
//        let width = Int(size.width)
//        let height = Int(size.height)
//
//        let bytesPerPixel = self.bitsPerPixel / self.bitsPerComponent
//        let destBytesPerRow = width * bytesPerPixel
//
//        guard let colorSpace = self.colorSpace else {
//            fatalError("Failed to get self.colorSpace")
//        }
//        guard let context = CGContext(data: nil,
//                                      width: width,
//                                      height: height,
//                                      bitsPerComponent: self.bitsPerComponent,
//                                      bytesPerRow: destBytesPerRow,
//                                      space: colorSpace,
//                                      bitmapInfo: )
//            else {
//            print(file_name)
//            fatalError("Failed to create CGContext")
//        }
//
//        context.interpolationQuality = .high
//        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
//
//        return context.makeImage()!
//    }
    
    func gray() -> [[UInt8]] {
        var bitmap = [[UInt8]](repeating: [UInt8](repeating: 0, count: self.width),
                               count: self.height)
        
        guard let data = self.dataProvider?.data,
              let bytes = CFDataGetBytePtr(data) else {
            fatalError("Couldn't access image data")
        }
        assert(self.colorSpace?.model == .rgb)
        let bytes_per_pixel = self.bitsPerPixel / self.bitsPerComponent
        
        var offset = 0
        for y in 0 ..< self.height {
            for x in 0 ..< self.width {
                offset = y * self.bytesPerRow + x * bytes_per_pixel
                bitmap[y][x] = calc_gray(r: bytes[offset],
                                         g: bytes[offset + 1],
                                         b: bytes[offset + 2])
            }
        }
        return bitmap
    }
}

private func calc_gray(r: UInt8, g: UInt8, b: UInt8) -> UInt8 {
    return UInt8(Double(r) * 0.3 + Double(g) * 0.59 + Double(b) * 0.11)
}
