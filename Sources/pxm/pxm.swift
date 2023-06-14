import Foundation
import txt

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
        var same = [String]()
        var similar = [String]()
        var distance = 0
        var results = Set<String>()
        var result = ""
        for i in files {
            same.removeAll()
            similar.removeAll()
            for j in files {
                if (i == j) {
                    continue
                }
                distance = hamming_distance(hashes[i]!, hashes[j]!)
                if distance == 0 {
                    same.append(j)
                } else if distance <= 5 {
                    similar.append(j)
                }
            }
            if (same.isEmpty && similar.isEmpty) {
                continue
            }
            result = "Same: open"
            same.append(i) /// Self is the same as self.
            if same.count > 1 {
                for j in same.sorted() {
                    result += " \(j)"
                }
                results.insert(result)
            }
            result = "Similar: open"
            similar.append(i)
            if similar.count > 1 {
                for j in similar.sorted() {
                    result += " \(j)"
                }
                results.insert(result)
            }
        }
        for i in results {
            print(i)
        }
    }
}
