import Foundation

final class PhotoViewModel {
    private let fetchPhotosUseCase: FetchPhotosUseCase
    private var photos: [PhotoEntity] = []
    var photoSearchResult: [PhotoEntity] = []
    private var currentPage = 1
    var isLoading = false
    var onPhotosUpdated: (() -> Void)?

    init(fetchPhotosUseCase: FetchPhotosUseCase = FetchPhotosUseCase()) {
        self.fetchPhotosUseCase = fetchPhotosUseCase
    }

    func loadPhotos() {
        guard !isLoading else { return }
        isLoading = true

        fetchPhotosUseCase.execute(page: currentPage, limit: 100) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let newPhotos):
                self.photos.append(contentsOf: newPhotos)
                self.photoSearchResult = self.photos
                self.onPhotosUpdated?()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func refreshPhotos() {
        currentPage = 1
        photos.removeAll()
        photoSearchResult.removeAll()
        loadPhotos()
    }

    func loadMoreIfNeeded(currentIndex: Int) {
        if currentIndex == photos.count - 1 {
            currentPage += 1
            loadPhotos()
        }
    }

    func getPhoto(at index: IndexPath) -> PhotoEntity {
        return photoSearchResult[index.row]
    }

    func getPhotoCount() -> Int {
        return photoSearchResult.count
    }

    func searchPhoto(keyword: String) {
        photoSearchResult = keyword.isEmpty
            ? photos
            : photos.filter {
                $0.author.lowercased().contains(keyword.lowercased()) ||
                    $0.id.contains(keyword)
            }
        onPhotosUpdated?()
    }
}
