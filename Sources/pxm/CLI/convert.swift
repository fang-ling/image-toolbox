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
    var quality : Float = 1
    
    @Flag(name: .customLong("copy-timestamp"))
    var copy_timestamp = true
    /* Output file */
    @Argument
    var output_file : String
    
    func run() throws {
      /* Convert */
      image_convert(from: input_file, to: output_file, quality: quality)
      /* Timestamp */
      if copy_timestamp {
        do {
          let ars = try FileManager.default.attributesOfItem(atPath: input_file)
          let c_date = ars[FileAttributeKey.creationDate]!
          let m_date = ars[FileAttributeKey.modificationDate]!
          try FileManager.default.setAttributes(
            [FileAttributeKey.creationDate : c_date],
            ofItemAtPath: output_file
          )
          try FileManager.default.setAttributes(
            [FileAttributeKey.modificationDate : m_date],
            ofItemAtPath: output_file
          )
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }
}
