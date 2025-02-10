import Foundation

enum APIConstants {
    static private let baseURL = "https://picsum.photos"

    enum Endpoints {
        static func photosList(page: Int, limit: Int) -> String {
            return "\(APIConstants.baseURL)/v2/list?page=\(page)&limit=\(limit)"
        }
    }
}
