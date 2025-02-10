import UIKit

final class PhotoTableViewCell: UITableViewCell {
    private let photoImageView = UIImageView()
    private let authorLabel = UILabel()
    private let sizeLabel = UILabel()
    let imageCache = NSCache<NSString, UIImage>()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))
        contentView.addSubview(authorLabel)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(photoImageView)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.sizeToFit()

        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            photoImageView.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: -5),
            authorLabel.bottomAnchor.constraint(equalTo: sizeLabel.topAnchor, constant: 0),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            sizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            sizeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            sizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with photo: PhotoEntity) {
        authorLabel.text = "Author: \(photo.author)"
        sizeLabel.text = "Size: \(Int(photo.thumbnailSize.width)) x \(Int(photo.thumbnailSize.height))"

        if let cachedImage = imageCache.object(forKey: photo.thumbnailUrl as NSString) {
            photoImageView.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: URL(string: photo.thumbnailUrl)!) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    self?.imageCache.setObject(image, forKey: photo.thumbnailUrl as NSString)
                    DispatchQueue.main.async {
                        self?.photoImageView.image = image
                    }
                }
            }.resume()
        }
    }
}
