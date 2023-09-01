//
//  convert.swift
//
//
//  Created by Fang Ling on 2023/9/1.
//

import ArgumentParser
import Foundation
import ImageCodec
import UniformTypeIdentifiers

extension pxm {
    struct convert : ParsableCommand {
        static var configuration = CommandConfiguration(
          abstract: "Convert between image formats."
        )

        /* Input file */
        @Argument
        var input_file : String
        /* Output options */
        @Option(
          name: .shortAndLong,
          help: "JPEG/HEIC compression level in the range 0.0 to 1.0."
        )
        var quality : Float = 0.8

        @Flag(name: .customLong("copy-timestamp"))
        var copy_timestamp = true
        /* Output file */
        @Argument
        var output_file : String

        func run() throws {
            /* Decode */
            let (pixels, metadata) = image_decode(file_path: input_file)
            if pixels == nil || metadata == nil {
                fatalError("unable to decode \(input_file)")
            }
            /* Encode */
            image_encode(
              file_path: output_file,
              pixels: pixels!,
              metadata: metadata!,
              type: UTType(
                filenameExtension: output_file.components(separatedBy: ".").last!
              )!,
              quality: quality
            )
            /* Timestamp */
            if copy_timestamp {
                do {
                    let iattrs = try FileManager.default.attributesOfItem(
                      atPath: input_file
                    )
                    try FileManager.default.setAttributes(
                      [
                        FileAttributeKey.creationDate : iattrs[
                          FileAttributeKey.creationDate
                        ]!
                      ],
                      ofItemAtPath: output_file
                    )
                    try FileManager.default.setAttributes(
                      [
                        FileAttributeKey.modificationDate : iattrs[
                          FileAttributeKey.modificationDate
                        ]!
                      ],
                      ofItemAtPath: output_file
                    )
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
