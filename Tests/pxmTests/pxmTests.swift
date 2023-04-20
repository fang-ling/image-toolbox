import XCTest
@testable import pxm

final class pxmTests: XCTestCase {
    @available(macOS 13.0, *)
    func test_cgImage_resize() {
        let
        png = FileManager.default.homeDirectoryForCurrentUser.path() +
              "1.png"
        guard let pngNSImage = png2jpg(png: NSImage(contentsOfFile: png)!) else {
            print(png)
            fatalError("Failed to read png file")
        }
        guard let pngCGImage = pngNSImage.cgImage(forProposedRect: nil,
                                         context: nil,
                                         hints: nil) else {
            fatalError("Failed to convert to CGImage")
        }
        
        var resized = pngCGImage.resize(width: 32, height: 32)!
        XCTAssertEqual(resized.width, 32)
        XCTAssertEqual(resized.height, 32)
        
        let jpg = FileManager.default.homeDirectoryForCurrentUser.path() +
                  "1.jpg"
        guard let jpgNSImage = NSImage(contentsOfFile: jpg) else {
            fatalError("Failed to read png file")
        }
        guard let jpgCGImage = jpgNSImage.cgImage(forProposedRect: nil,
                                         context: nil,
                                         hints: nil) else {
            fatalError("Failed to convert to CGImage")
        }
        resized = jpgCGImage.resize(width: 32, height: 32)!
        XCTAssertEqual(resized.width, 32)
        XCTAssertEqual(resized.height, 32)
    }
}
