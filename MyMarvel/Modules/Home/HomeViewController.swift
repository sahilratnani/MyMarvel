//
//  HomeViewController.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 07/05/23.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: HomeViewModel? = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Title"
        titleLabel.text = "Marvel Home"
        setupTableView()
        viewModel?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchCharacterList()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.registerCell(cellClass: CharacterListCell.self)
    }
}

extension HomeViewController: UITableViewDelegate  {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (viewModel?.numberOfItems ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: CharacterListCell.self, indexPath: indexPath)
        guard let vm = viewModel else {
            assertionFailure("Could not get the view model")
            return cell
        }
        if indexPath.row > vm.numberOfItems-1 {
            vm.loadMoreCharacters()
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
        viewModel.loadMoreCharacters(count: maxIndex.row - viewModel.numberOfItems-1 )
    }
       
       func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {

       }
}
