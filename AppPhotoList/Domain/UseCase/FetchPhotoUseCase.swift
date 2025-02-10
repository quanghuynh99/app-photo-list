import Foundation

class FetchPhotosUseCase {
    private let repository: PhotoRepositoryProtocol

    init(repository: PhotoRepositoryProtocol = PhotoRepository()) {
        self.repository = repository
    }

    func execute(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], Error>) -> Void) {
        repository.getPhotos(page: page, limit: limit, completion: completion)
    }
}
