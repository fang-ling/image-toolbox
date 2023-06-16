import Foundation
import txt
import xhl

@main
public struct pxm {
    public static func main() {
        /* List current working directory */
        var files : [String] = []
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: ".")
        } catch {
            print(error.localizedDescription)
        }

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
        var same = UnionFindSet<String>()
        var similar = UnionFindSet<String>()
        for file in files {
            same.make_set(file)
            similar.make_set(file)
        }
        for i in files {
            for j in files {
                if (i == j) {
                    continue
                }
                let distance = hamming_distance(hashes[i]!, hashes[j]!)
                if distance == 0 { /* File i and j are equal */
                    same.union(i, j)
                } else if distance <= 5 {
                    similar.union(i, j)
                }
            }
        }
        var result_same = [String : Set<String>]()
        var result_similar = [String : Set<String>]()
        for file in files {
            let set = same.find_set(file)
            if result_same[set] == nil {
                result_same[set] = Set<String>()
            }
            result_same[set]!.insert(file)
        }
        for file in files {
            let set = similar.find_set(file)
            if result_similar[set] == nil {
                result_similar[set] = Set<String>()
            }
            result_similar[set]!.insert(file)
        }
        print("Same:")
        for i in result_same {
            if i.value.count > 1 {
                print("open ", terminator: "")
                print(i.value.map {"'\($0)'"}.joined(separator: " "))
            }
        }
        print("Similar:")
        for i in result_similar {
            if i.value.count > 1 {
                print("open ", terminator: "")
                print(i.value.map {"'\($0)'"}.joined(separator: " "))
            }
        }
    }
}
