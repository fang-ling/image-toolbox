//
//  pHash.swift
//
//
//  Created by Fang Ling on 2023/4/18.
//

import Foundation
import txt
import lml

func phash(_ rgba64 : RGBA64) -> UInt64 {
    var hash : UInt64 = 0

    /* 1. reduce size */
    let resized = Resizer.bilinear_interpolation(rgba64, width: 32, height: 32)
    /* 2. reduce color */
    let gray = Grayscale16(rgba64: resized)
    /* 3. compute the DCT */
    let A = gray.pixels.map { Double($0) }
    let B = dct_2d_ii(A, rows: gray.height, cols: gray.width)
    /* 4. reduce the DCT */
    var C = [Double]()
    for i in 0 ..< 8 {
        for j in 0 ..< 8 {
            C.append(B[i * gray.width + j])
        }
    }
    /* 5. compute the average value */
    var averge = C.reduce(0, { x, y in x + y })
    averge -= C[0] /* excluding the first term */
    averge /= 63
    /* 6. further reduce the DCT */
    for c in C {
        hash <<= 1
        if c >= averge {
            hash += 1
        }
    }

    return hash
}

func hamming_distance(_ lhs : UInt64, _ rhs : UInt64) -> Int {
    var xor = lhs ^ rhs
    var distance = 0
    while xor != 0 {
        distance += 1
        xor = xor & (xor - 1)
    }
    return distance
}
