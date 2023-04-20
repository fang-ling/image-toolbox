//
//  dct.swift
//  
//
//  Created by Fang Ling on 2023/4/18.
//

import Foundation

/* Discrete Cosine Transform */

let π = 3.14159265358979323846

func dct(matrix: Matrix, block_size : Int) -> Matrix {
    let n = block_size
    // Double version of n, i, j, u, v
    let dn = Double(n)
    var di = 0.0
    var dj = 0.0
    var du = 0.0
    var dv = 0.0
    
    var dct_coeff = Matrix(rows: n, cols: n)
    for u in 0 ..< n {
        du = Double(u)
        for v in 0 ..< n {
            dct_coeff[u, v] = 0
            dv = Double(v)
            
            for i in 0 ..< n {
                di = Double(i)
                for j in 0 ..< n {
                    dj = Double(j)
                    
                    dct_coeff[u, v] += matrix[i, j] *
                                       cos(π * (di + 0.5) * du / dn) *
                                       cos(π * (dj + 0.5) * dv / dn)
                    
                }
            }
        }
    }
    return dct_coeff
}

//private func c(_ u : Int, n : Int) -> Double {
//    return u == 0 ? sqrt(1 / Double(n)) : sqrt(2 / Double(n))
//}
//
//private func F(_ u : Int, _ v : Int, _ bitmap : [[UInt8]]) -> Double {
//    let n = bitmap.count
//    var sum = 0.0
//    for i in bitmap.indices {
//        for j in bitmap[i].indices {
//            sum += Double(bitmap[i][j]) *
//                   cos(Double(u) * (Double(i) + 0.5) * PI / Double(n)) *
//                   cos(Double(v) * (Double(j) + 0.5) * PI / Double(n))
//        }
//    }
//    return sum * c(u, n: n) * c(v, n: n)
//}
//
//func dct(bitmap : [[UInt8]]) -> [[Double]] {
//    var tr = [[Double]](repeating: [Double](repeating: 0,
//                                            count: bitmap[0].count),
//                        count: bitmap.count)
//    for i in bitmap.indices {
//        for j in bitmap.indices {
//            tr[i][j] = F(i, j, bitmap)
//        }
//    }
//    return tr
//}
