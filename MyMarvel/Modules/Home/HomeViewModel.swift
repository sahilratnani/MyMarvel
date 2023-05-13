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

    var numberOfItems: Int {
        characters.count
    }

    func getInfo(for indexPath: IndexPath) -> (name: String, desc: String, imageURL: String?) {
        let character = characters[indexPath.row]
        return (name: character.name ?? "", desc: character.description ?? "", imageURL: character.thumbnail?.url)
    }

    func fetchCharacterList() {
        APIService.getAllCharacters { result in
            switch result {
            case .success(let characters):
                self.characters = characters
                self.delegate?.didUpdate(with: .success)
            case .failure(let error):
                self.delegate?.didUpdate(with: .error(error))
                break
            }
        }
    }
}
