import Foundation

import Foundation

protocol PhotoServiceProtocol {
    func fetchPhotos(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], Error>) -> Void)
}

final class PhotoService: PhotoServiceProtocol {
    func fetchPhotos(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], Error>) -> Void) {
        let urlString = "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }

            do {
                let photos = try JSONDecoder().decode([PhotoEntity].self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
