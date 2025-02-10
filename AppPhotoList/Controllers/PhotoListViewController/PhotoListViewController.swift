import UIKit

class PhotoListViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = PhotoViewModel()
    private let refreshControl = UIRefreshControl()
    private var searchBar = UISearchBar()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        viewModel.loadPhotos()
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Photos"
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.tableFooterView = loadingIndicator
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        searchBar.showsCancelButton = true

        searchBar.delegate = self
        searchBar.placeholder = "Search by Author or ID"
        navigationItem.titleView = searchBar

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupBinding() {
        viewModel.onPhotosUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                self?.loadingIndicator.stopAnimating()
            }
        }
    }

    @objc private func refreshData() {
        viewModel.refreshPhotos()
    }

    private func showBottomIndicator(_ show: Bool) {
        if show {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension PhotoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getPhotoCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PhotoTableViewCell()
        let photo = viewModel.getPhoto(at: indexPath)
        cell.configure(with: photo)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = viewModel.getPhotoCount() - 1
        if indexPath.row == lastRowIndex {
            showBottomIndicator(true)
            viewModel.loadMoreIfNeeded(currentIndex: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getPhoto(at: indexPath).thumbnailSize.height + 50
    }
}

// MARK: UISearchBarDelegate

extension PhotoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = searchBar.text as NSString? else { return true }
        let newLength = currentText.length + text.count - range.length
        if newLength > 15 {
            return false
        }
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*():.,<>/\\[]? "
        let characterSet = CharacterSet(charactersIn: allowedCharacters)
        return text.rangeOfCharacter(from: characterSet.inverted) == nil
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*():.,<>/\\[]? "
        let filteredText = searchText.filter { allowedCharacters.contains($0) }
        if filteredText != searchText {
            searchBar.text = String(filteredText.prefix(15))
        }
        viewModel.searchPhoto(keyword: filteredText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
