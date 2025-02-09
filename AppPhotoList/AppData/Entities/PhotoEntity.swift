import Foundation

public struct PhotoEntity: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let download_url: String
}
