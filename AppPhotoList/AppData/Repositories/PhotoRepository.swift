import Foundation

protocol PhotoRepositoryProtocol {
    func fetchPhotos(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], Error>) -> Void)
}

final class PhotoRepository: PhotoRepositoryProtocol {
    private let apiService: PhotoServiceProtocol

    init(apiService: PhotoServiceProtocol = PhotoService()) {
        self.apiService = apiService
    }

    func fetchPhotos(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], Error>) -> Void) {
        apiService.fetchPhotos(page: page, limit: limit, completion: completion)
    }
}
