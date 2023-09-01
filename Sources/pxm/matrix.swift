//
//  matrix.swift
//
//
//  Created by Fang Ling on 2023/4/20.
//

import Foundation
import Accelerate

/*struct Matrix {
    var grid : [Double]
    var rows : Int
    var cols : Int

    init(rows : Int, cols : Int, repeated_value : Double) {
        self.rows = rows
        self.cols = cols
        grid = [Double](repeating: repeated_value, count: rows * cols)
    }

    init(rows : Int, cols : Int) {
        self.init(rows: rows, cols: cols, repeated_value: 0)
    }
}

/* subscript */
extension Matrix {
    subscript(row : Int, col : Int) -> Double {
        get {
            assert(check_index(row: row, col: col), "Index out of range")
            return grid[row * cols + col]
        }
        set {
            assert(check_index(row: row, col: col), "Index out of range")
            grid[row * cols + col] = newValue
        }
    }
}

/* utils */
extension Matrix {
    func check_index(row : Int, col : Int) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < cols
    }

    static func check_proper_shape_add(lhs : Matrix, rhs : Matrix) -> Bool {
        return lhs.rows == rhs.rows && lhs.cols == rhs.cols
    }

    static func check_proper_shape_mul(lhs : Matrix, rhs : Matrix) -> Bool {
        /// lhs: M-by-P, rhs: P-by-N. i.e. lhs.cols == rhs.rows
        return lhs.cols == rhs.rows
    }
}*/

/* operators */
//extension Matrix {
//    static func + (lhs : Matrix, rhs : Matrix) -> Matrix {
//        assert(check_proper_shape_add(lhs: lhs, rhs: rhs))
//        var result = Matrix(rows: lhs.rows, cols: rhs.cols)
//        vDSP_vaddD(lhs.grid, vDSP_Stride(1),
//                   rhs.grid, vDSP_Stride(1),
//                   &result.grid, vDSP_Stride(1),
//                   vDSP_Length(lhs.grid.count))
//        return result
//    }
//
//    static func - (lhs : Matrix, rhs : Matrix) -> Matrix {
//        assert(check_proper_shape_add(lhs: lhs, rhs: rhs))
//        var result = Matrix(rows: lhs.rows, cols: rhs.cols)
//        /// First B, then A
//        vDSP_vsubD(rhs.grid, vDSP_Stride(1),
//                   lhs.grid, vDSP_Stride(1),
//                   &result.grid, vDSP_Stride(1),
//                   vDSP_Length(lhs.grid.count))
//        return result
//    }

//    static func * (lhs : Matrix, rhs : Matrix) -> Matrix {
//        assert(check_proper_shape_mul(lhs: lhs, rhs: rhs))
//        /// lhs: lhs: M-by-P, rhs: P-by-N. Will result a C: M-by-N
//        var result = Matrix(rows: lhs.rows, cols: rhs.cols)
//        vDSP_mmulD(lhs.grid, vDSP_Stride(1),
//                   rhs.grid, vDSP_Stride(1),
//                   &result.grid, vDSP_Stride(1),
//                   vDSP_Length(lhs.rows),
//                   vDSP_Length(rhs.cols),
//                   vDSP_Length(lhs.cols))
//        return result
//    }
//}
