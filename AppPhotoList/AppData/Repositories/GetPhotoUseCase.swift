import Foundation

class FetchPhotosUseCase {
    private let repository: PhotoRepositoryProtocol

    init(repository: PhotoRepositoryProtocol = PhotoRepository()) {
        self.repository = repository
    }

    func excute(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], Error>) -> Void) {
        repository.fetchPhotos(page: page, limit: limit, completion: completion)
    }
}
