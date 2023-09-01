//
//  dedup.swift
//
//
//  Created by Fang Ling on 2023/6/21.
//

import ArgumentParser
import Foundation
import ImageCodec
import xhl

extension pxm {
    struct Dedup : ParsableCommand {
        static var configuration = CommandConfiguration(
          abstract: "Find exact and near duplicates in an image collection."
        )

        func run() throws {
            /* List current working directory */
            var files = try FileManager.default.contentsOfDirectory(atPath: ".")

            /* Only hash images */
            files = files.filter {
                $0.lowercased().hasSuffix(".jpg") ||
                  $0.lowercased().hasSuffix(".heic") ||
                  $0.lowercased().hasSuffix(".webp") ||
                  $0.lowercased().hasSuffix(".png") ||
                  $0.lowercased().hasSuffix(".jpeg")
            }

            /* Hash images */
            var hashes : [String : UInt64] = [:]
            for file in files {
                guard let rgba64 = Decoder.decode(from: file) else {
                    fatalError("Failed to decode image: \(file)")
                }
                hashes[file] = phash(rgba64)
            }

            /* Comparison */
            let threshold = 6
            var similars = [UnionFindSet<String>](
              repeating: UnionFindSet<String>(),
              count: threshold
            )
            for file in files {
                for i in similars.indices {
                    similars[i].make_set(file)
                }
            }
            for i in files {
                for j in files {
                    if (i == j) {
                        continue
                    }
                    let distance = hamming_distance(hashes[i]!, hashes[j]!)
                    for k in similars.indices {
                        if distance == k {
                            similars[k].union(i, j)
                        }
                    }
                }
            }
            var results = [[String : Set<String>]](
              repeating: [String : Set<String>](),
              count: threshold
            )
            for i in similars.indices {
                for file in files {
                    let pset = similars[i].find_set(file)
                    if results[i][pset] == nil {
                        results[i][pset] = Set<String>()
                    }
                    results[i][pset]!.insert(file)
                }
            }
            for j in results.indices {
                print("Hamming Distances = \(j)")
                for i in results[j] {
                    if i.value.count > 1 {
                        print("open ", terminator: "")
                        print(
                          i.value.map{"'\($0)'"}.sorted().joined(separator: " ")
                        )
                    }
                }
            }
        }
    }
}
