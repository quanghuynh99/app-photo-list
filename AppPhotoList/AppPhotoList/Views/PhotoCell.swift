import UIKit

class PhotoCell: UITableViewCell {
    private let photoImageView = UIImageView()
    private let authorLabel = UILabel()
    private let sizeLabel = UILabel()
    let imageCache = NSCache<NSString, UIImage>()

    private var photoHeight: NSLayoutConstraint?
    private var photoWidth: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let aspectRatio = image.size.width / image.size.height
        let newSize: CGSize
        if aspectRatio > 1 {
            newSize = CGSize(width: targetSize.width, height: targetSize.width / aspectRatio)
        } else {
            newSize = CGSize(width: targetSize.height * aspectRatio, height: targetSize.height)
        }
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in image.draw(in: CGRect(origin: .zero, size: newSize)) }
    }

    private func setupUI() {
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 8
        photoImageView.translatesAutoresizingMaskIntoConstraints = false

        authorLabel.font = UIFont.boldSystemFont(ofSize: 16)
        authorLabel.numberOfLines = 1
        authorLabel.translatesAutoresizingMaskIntoConstraints = false

        sizeLabel.font = UIFont.systemFont(ofSize: 14)
        sizeLabel.textColor = .darkGray
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [authorLabel, sizeLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(photoImageView)
        contentView.addSubview(stackView)

        photoHeight = photoImageView.heightAnchor.constraint(equalToConstant: 200)
        photoWidth = photoImageView.widthAnchor.constraint(equalToConstant: 200)
        photoWidth?.isActive = true
        photoHeight?.isActive = true

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with photo: PhotoEntity) {
        dump(photo.download_url)
        loadImage(from: photo.download_url) { [weak self] image in
            guard let self else { return }
            self.photoImageView.image = image
        }
    }

    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(cachedImage)
            return
        }

        DispatchQueue.global(qos: .background).async {
            guard let imageUrl = URL(string: url),
                  let data = try? Data(contentsOf: imageUrl),
                  let image = UIImage(data: data)
            else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            self.imageCache.setObject(image, forKey: url as NSString)
            DispatchQueue.main.async { completion(image) }
        }
    }
}

extension UIImage {
    func resizeImage(targetSize: CGSize = .init(width: 480, height: 480)) -> UIImage {
        let aspectRatio = size.width / size.height
        let newSize: CGSize
        if aspectRatio > 1 {
            newSize = CGSize(width: targetSize.width, height: targetSize.width / aspectRatio)
        } else {
            newSize = CGSize(width: targetSize.height * aspectRatio, height: targetSize.height)
        }
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in draw(in: CGRect(origin: .zero, size: newSize)) }
    }
}
