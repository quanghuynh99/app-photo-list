import Foundation

struct PhotoEntity: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let download_url: String
    let url: String

    var thumbnailUrl: String {
        let components = download_url.split(separator: "/")
        guard components.count >= 3,
              let originalWidth = Int(components[components.count - 2]),
              let originalHeight = Int(components[components.count - 1])
        else {
            return download_url
        }
        let newWidth = originalWidth / 10
        let newHeight = originalHeight / 10
        let baseURL = components.dropLast(2).joined(separator: "/")
        return "\(baseURL)/\(newWidth)/\(newHeight)"
    }

    var thumbnailSize: CGSize {
        return CGSize(width: CGFloat(width / 10), height: CGFloat(height / 10))
    }
}
