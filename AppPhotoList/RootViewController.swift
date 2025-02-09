import UIKit

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "App: PhotoList"
        view.backgroundColor = .white
        let button = UIButton()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        button.setTitle("Load Photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapLoadPhoto), for: .touchUpInside)
    }

    @objc private func didTapLoadPhoto() {
        let viewModel = PhotoListViewModel()
        let photoListViewController = PhotoListViewController(viewModel: viewModel)
        navigationController?.pushViewController(photoListViewController, animated: true)
    }
}
