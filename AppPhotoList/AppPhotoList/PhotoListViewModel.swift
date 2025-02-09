import Foundation

class PhotoListViewModel {
    private let fetchPhotosUseCase: FetchPhotosUseCase
    private var photos: [PhotoEntity] = []
    private var currentPage = 1
    var isLoading = false
    var onPhotosUpdated: (() -> Void)?
        
    init(fetchPhotosUseCase: FetchPhotosUseCase = FetchPhotosUseCase()) {
        self.fetchPhotosUseCase = fetchPhotosUseCase
    }
        
    func loadPhotos() {
        guard !isLoading else { return }
        isLoading = true
            
        fetchPhotosUseCase.excute(page: currentPage, limit: 100) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let newPhotos):
                self.photos.append(contentsOf: newPhotos)
                self.onPhotosUpdated?()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
        
    func refreshPhotos() {
        currentPage = 1
        photos.removeAll()
        loadPhotos()
    }
        
    func loadMoreIfNeeded(currentIndex: Int) {
        if currentIndex == photos.count - 1 {
            currentPage += 1
            loadPhotos()
        }
    }
        
    func getPhoto(at index: Int) -> PhotoEntity {
        return photos[index]
    }
        
    func getPhotoCount() -> Int {
        return photos.count
    }

//    func searchPhotos(keyword: String) {
//        let cleanedQuery = cleanSearchQuery(keyword)
//        if cleanedQuery.isEmpty {
//            photos = allPhotos
//        } else {
//            photos = allPhotos.filter {
//                $0.author.lowercased().contains(cleanedQuery.lowercased()) ||
//                    $0.id.contains(cleanedQuery)
//            }
//        }
//        onDataUpdated?()
//    }
//
//    private func cleanSearchQuery(_ keyword: String) -> String {
//        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*():.,<>/\\[]?")
//        return String(keyword.unicodeScalars.filter { allowedCharacters.contains($0) }).prefix(15).description
//    }
}
