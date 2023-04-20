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
    guard let cgi = png.cgImage(forProposedRect: nil,
                                context: nil,
                                hints: nil) else {
        return nil
    }
    let bitmapRep = NSBitmapImageRep(cgImage: cgi)
    guard let
    jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg,
                                        properties: [:]) else {
        return nil
    }
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
                                      bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        
        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        return context.makeImage()
    }

    func gray() -> Matrix? {
        var matrix = Matrix(rows: width, cols: height)
        
        let bytes_per_pixel = bitsPerPixel / bitsPerComponent
        let bytes_per_row = width * bytes_per_pixel
        let
        pixels = UnsafeMutablePointer<UInt8>.allocate(capacity: width *
                                                                height *
                                                                bytes_per_pixel)
        guard let color_space = colorSpace else { return nil }
        guard let context = CGContext(data: pixels,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytes_per_row,
                                      space: color_space,
                                      bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var offset = 0
        for x in 0 ..< width {
            for y in 0 ..< height {
                offset = bytes_per_pixel * (width * y + x)
                matrix[x, y] = calc_gray(r: pixels[offset],
                                         g: pixels[offset + 1],
                                         b: pixels[offset + 2])
            }
        }
        
        return matrix
    }
}

private func calc_gray(r: UInt8, g: UInt8, b: UInt8) -> Double {
    return Double(r) * 0.3 + Double(g) * 0.59 + Double(b) * 0.11
}
