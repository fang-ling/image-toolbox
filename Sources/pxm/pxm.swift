import Foundation
import AppKit

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
        files = files.filter({
            $0.lowercased().hasSuffix(".jpg") ||
            $0.lowercased().hasSuffix(".png") ||
            $0.lowercased().hasSuffix(".jpeg")
        })
        
        /* Hash images */
        var hashes : [String : String] = [:]
        for i in files {
            guard let nsImage = NSImage(contentsOfFile: i) else {
                fatalError("Failed to read \(i)")
            }
            
            guard let nsImage = nsImage.resize(CGSize(width: 16,
                                                      height: 16)) else {
                fatalError("Failed to resize \(i)")
            }
            guard let cgImage = nsImage.cgImage(forProposedRect: nil,
                                                context: nil,
                                                hints: nil) else {
                fatalError("Failed to convert \(i) from NSImage to CGImage")
            }
            
            hashes[i] = phash(dct(bitmap: cgImage.gray()))
        }
        
        /* Compare */
        var same = [String]()
        var similar = [String]()
        var distance = 0
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
                } else if distance < 3 {
                    //similar.append(j)
                }
            }
            print("""
                  Image: \(i)
                  The same images: \(same)
                  Similar images: \(similar)
                  """)
        }
    }
}
