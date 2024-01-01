//
//  pHash.swift
//
//
//  Created by Fang Ling on 2023/4/18.
//

import Foundation
import ImageCodec
import ImageTransformation

let W = 32
let H = 32

func phash(_ src : PixelBuffer) -> UInt64 {
  var hash : UInt64 = 0
  
  var I = [UInt8]()
  /* 1. reduce color */
  for i in 0 ..< src.components[0].count {
    I.append(
      UInt8(
        Double(
          Int(src.components[1][i]) +
          Int(src.components[2][i]) +
          Int(src.components[3][i])
        ) / 3
      )
    )
  }
  /* 2. reduce size */
  I = bilinear_interpolation(
    I,
    src_width: src.width,
    src_height: src.height,
    dst_width: W,
    dst_height: H
  )
  /* 3. compute the DCT */
  let I_d = dct_2d(I.map { Double($0) }, width: W, height: H)
  /* 4. reduce the DCT */
  var J = [Double]()
  for r in 0 ..< 8 {
    for c in 0 ..< 8 {
      J.append(I_d[r * W + c])
    }
  }
  /* 5. compute the average value */
  var averge = J.reduce(0, { x, y in x + y })
  averge -= J[0] /* excluding the first term */
  averge /= 63
  /* 6. further reduce the DCT */
  for c in J {
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
