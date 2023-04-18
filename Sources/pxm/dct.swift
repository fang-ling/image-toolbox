//
//  dct.swift
//  
//
//  Created by Fang Ling on 2023/4/18.
//

import Foundation

/* Discrete Cosine Transform */

let PI = 3.14159265358979323846

private func c(_ u : Int, n : Int) -> Double {
    return u == 0 ? sqrt(1 / Double(n)) : sqrt(2 / Double(n))
}

private func F(_ u : Int, _ v : Int, _ bitmap : [[UInt8]]) -> Double {
    let n = bitmap.count
    var sum = 0.0
    for i in bitmap.indices {
        for j in bitmap[i].indices {
            sum += Double(bitmap[i][j]) *
                   cos(Double(u) * (Double(i) + 0.5) * PI / Double(n)) *
                   cos(Double(v) * (Double(j) + 0.5) * PI / Double(n))
        }
    }
    return sum * c(u, n: n) * c(v, n: n)
}

func dct(bitmap : [[UInt8]]) -> [[Double]] {
    var tr = [[Double]](repeating: [Double](repeating: 0,
                                            count: bitmap[0].count),
                        count: bitmap.count)
    for i in bitmap.indices {
        for j in bitmap.indices {
            tr[i][j] = F(i, j, bitmap)
        }
    }
    return tr
}
