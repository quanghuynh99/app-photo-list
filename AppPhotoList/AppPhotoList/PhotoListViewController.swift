import Foundation
import UIKit

class PhotoListViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let photoTableView = UITableView()
    private let photoSearchedResultsTableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isLoading = false

    private let viewModel: PhotoListViewModel

    init(viewModel: PhotoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadPhotos()
    }

    private func setupUI() {
        title = "Photo List"
        view.backgroundColor = .white

        photoTableView.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")
        photoTableView.delegate = self
        photoTableView.dataSource = self
        photoTableView.separatorStyle = .none
        photoTableView.refreshControl = UIRefreshControl()
        photoTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true

        view.addSubview(photoTableView)
        photoTableView.frame = view.bounds
    }

    private func setupBindings() {
        viewModel.onPhotosUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.photoTableView.reloadData()
            }
        }
    }

    @objc private func refreshData() {
        viewModel.refreshPhotos()
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate

extension PhotoListViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.searchPhotos(keyword: searchText)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getPhotoCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PhotoCell()
        let photo = viewModel.getPhoto(at: indexPath.row)
        cell.configure(with: photo)
        return cell
    }
}
