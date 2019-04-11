import Foundation
import UIKit

struct Title {
    var fullName: String
    var Russian: String
    var Original: String
    var Episodes: String
}
struct Information {
    var Year: String
    var Genres: String
    var Country: String
    var Episodes: String
    var Release: String
    var Director: String
    var Author: String
    var Dubbers: String
    var Translators: String
    var Studio: String
    var Description: String
}
struct Rating {
    var RType: Int
    var Grade: String
    var Votes: String
}
struct fullTitle {
    var ID: Int
    var Url: String
    var Title: Title
    var Uploader: String
    var Categories: [String]
    var Poster: String
    var Information: Information
    var Commentaries: Int
    var Rating: Rating

}
struct episodes {

    var Name: String
    var Url: String
}

struct user {
    var ID: Int
    var favCount: Int
    var username: String
    var password: String
}

struct user_firebase {
    var ID: String
    var name: String
    var Fav: [String] = [String]()
}

func md5(_ string: String) -> String {

    let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
    var digest = Array<UInt8>(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
    CC_MD5_Init(context)
    CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
    CC_MD5_Final(&digest, context)
    context.deallocate(capacity: 1)
    var hexString = ""
    for byte in digest {
        hexString += String(format: "%02x", byte)
    }

    return hexString
}

extension Array where Element: Equatable {

    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }

    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension String {
    func slice(from: String, to: String) -> String? {

        var result = (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
        if result == nil {
            return ""
        }
        return result
    }
}
