//
//  HomeViewController.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 07/05/23.
//

import UIKit

class HomeViewController: UIViewController {
    enum Tab: Int {
        case allCharacters = 0
        case bookmarked = 1
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    private var currentTab: Tab {
        Tab(rawValue: segmentControl.selectedSegmentIndex) ?? .allCharacters
    }

    var viewModel: HomeViewModel? = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Title"
        titleLabel.text = "Marvel Home"
        setupTableView()
        viewModel?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel?.loadCharacters()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.registerCell(cellClass: CharacterListCell.self)
    }

    
    @IBAction func segnmentDidChange(_ sender: UISegmentedControl) {
        viewModel?.filterByType(type: currentTab == .allCharacters ? .all : .bookmarked)
    }
}

extension HomeViewController: UITableViewDelegate  {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalItems = viewModel?.numberOfItems ?? 0
        if currentTab == .allCharacters {
            // Add 1 to show loading cell
            return totalItems > 0 ? totalItems+1 : totalItems
        } else {
           return totalItems
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: CharacterListCell.self, indexPath: indexPath)
        guard let vm = viewModel else {
            assertionFailure("Could not get the view model")
            return cell
        }
        if indexPath.row > vm.numberOfItems-1, currentTab == .allCharacters {
            vm.loadCharacters()
            cell.titleLabel.text = "Loading..."
            return cell
        }
        cell.configure(info: vm.getInfo(for: indexPath))
        cell.onBookmarked = {
            vm.toggleCharacterBookmark(at: indexPath.row)
        }
        return cell
    }
    
    
}

extension HomeViewController: ViewUpdatable {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .idle:
                break
            case .loading:
                break
            case .success:
                self?.tableView.reloadData()
            case .error(let error):
                print("error occured \(error)")
            }
        }
        
    }
}

extension HomeViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let viewModel = viewModel,
              let maxIndex = indexPaths.max(),
              maxIndex.row > (viewModel.numberOfItems - 1) else {
            return
        }
        print("prefetching")
        viewModel.loadCharacters(count: maxIndex.row - viewModel.numberOfItems-1 )
    }
       
       func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {

       }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.search(searchText)
    }
}
