//
//  HomeViewModel.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 13/05/23.
//

import Foundation

enum Types {
    case all, bookmarked
}

class HomeViewModel {
    var delegate: ViewUpdatable?
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }

    init() {
        state = .idle
    }

    private var characters: [Character] = [] {
        didSet {
            filterCharacters()
        }
    }
    private var filteredCharacters: [Character] = []
    private var selectedType: Types = .all {
        didSet {
            filterCharacters()
        }
    }

    private var maxLimit = 100
    private var isFetchingInProgress = false

    var numberOfItems: Int {
        filteredCharacters.count
    }

    private func filterCharacters() {
        switch selectedType {
        case .all:
            filteredCharacters = characters
            state = .success

        case .bookmarked:
            filteredCharacters = characters.filter { $0.bookmarked }
            state = .success
        }
    }

    func getInfo(for indexPath: IndexPath) -> (name: String, desc: String, imageURL: String?, isBookmarked: Bool) {
        let character = filteredCharacters[indexPath.row]
        return (name: character.name ?? "", desc: character.description ?? "", imageURL: character.thumbnail?.url, isBookmarked: character.bookmarked)
    }

    func toggleCharacterBookmark(at index: Int) {
        filteredCharacters[index].bookmarked.toggle()
    }

    func filterByType(type: Types) {
        self.selectedType = type
    }

}

// MARK: API Calls
extension HomeViewModel {
    func fetchCharacterList(offset: Int = 0, limit: Int = 20) {
        guard isFetchingInProgress == false else { return }
        isFetchingInProgress = true
        APIService.getAllCharacters(offset: offset, limit: limit) {[weak self] result in
            guard let self = self else { return }
            self.isFetchingInProgress = false
            self.handleResponse(result: result)
        }
    }

    private func handleResponse(result: Result<[Character], Error>) {
        guard selectedType == .all else { return }
        switch result {
        case .success(let characters):
            self.characters.append(contentsOf: characters)
            state = .success
        case .failure(let error):
            self.delegate?.didUpdate(with: .error(error))
            state = .error(error)
            break
        }
    }

    func loadMoreCharacters(count: Int = 20) {
        fetchCharacterList(offset: characters.count, limit: count > maxLimit ? maxLimit : count )
    }
}
