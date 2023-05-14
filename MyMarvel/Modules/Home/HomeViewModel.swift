//
//  HomeViewModel.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 13/05/23.
//

import Foundation

class HomeViewModel {
    var characters: [Character] = []
    var delegate: ViewUpdatable?
    private var maxLimit = 100
    private var isFetchingInProgress = false

    var numberOfItems: Int {
        characters.count
    }

    func getInfo(for indexPath: IndexPath) -> (name: String, desc: String, imageURL: String?, isBookmarked: Bool) {
        let character = characters[indexPath.row]
        return (name: character.name ?? "", desc: character.description ?? "", imageURL: character.thumbnail?.url, isBookmarked: character.bookmarked)
    }

    func toggleCharacterBookmark(at index: Int) {
        characters[index].bookmarked.toggle()
    }

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
        switch result {
        case .success(let characters):
            self.characters.append(contentsOf: characters)
            self.delegate?.didUpdate(with: .success)
        case .failure(let error):
            self.delegate?.didUpdate(with: .error(error))
            break
        }
    }

    func loadMoreCharacters(count: Int = 20) {
        fetchCharacterList(offset: characters.count, limit: count > maxLimit ? maxLimit : count )
    }
}
