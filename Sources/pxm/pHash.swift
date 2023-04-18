//
//  pHash.swift
//  
//
//  Created by Fang Ling on 2023/4/18.
//

import Foundation

let HASH_LENGTH = 8 /// 8 * 8 = 64

func phash(_ tr : [[Double]]) -> String {
    var hash = ""
    var average = 0.0
    var subarray = [[Double]](repeating: [Double](), count: HASH_LENGTH)
    for i in 0 ..< HASH_LENGTH {
        for j in 0 ..< HASH_LENGTH {
            subarray[i].append(tr[i][j])
            average += subarray[i][j]
        }
    }
    average /= Double(HASH_LENGTH * HASH_LENGTH)
    
    for i in 0 ..< HASH_LENGTH {
        for j in 0 ..< HASH_LENGTH {
            if subarray[i][j] >= average {
                hash += "1"
            } else {
                hash += "0"
            }
        }
    }
    
    return hash
}

func hamming_distance(_ lhs : String, _ rhs : String) -> Int {
    return zip(lhs, rhs).filter({ $0 != $1 }).count
}
