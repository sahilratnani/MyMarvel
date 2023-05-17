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
    private var apiService: APIServiceable
    private var realmService: RealmServiceable

    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }

    init(apiService: APIServiceable = APIService(), realmService: RealmServiceable = RealmService.defaultInstance) {
        self.apiService = apiService
        self.realmService = realmService
        state = .idle
    }

    private var searchText = ""
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

    func loadCharacters(count: Int = 20) {
        fetchCharacterList(offset: characters.count, limit: count > maxLimit ? maxLimit : count )
    }

    private func filterCharacters() {
        switch selectedType {
        case .all:
            filteredCharacters = characters.filter { containsSearchText(text: $0.name ?? "") }
            state = .success

        case .bookmarked:
            filteredCharacters = characters.filter { $0.bookmarked && containsSearchText(text: $0.name ?? "") }
            state = .success
        }
    }

    //Check for `searchText` within provided text.
    private func containsSearchText(text: String) -> Bool {
        guard searchText.isEmpty == false else {
            return true
        }
        return text.localizedCaseInsensitiveContains(searchText)
    }

    func getInfo(for indexPath: IndexPath) -> (name: String, desc: String, imageURL: String?, isBookmarked: Bool) {
        let character = filteredCharacters[indexPath.row]
        return (name: character.name ?? "", desc: character.desc ?? "", imageURL: character.thumbnail?.url, isBookmarked: character.bookmarked)
    }

    func toggleCharacterBookmark(at index: Int) {
        realmService.update(filteredCharacters[index]) { object in
            object.bookmarked.toggle()
        }
    }

    func filterByType(type: Types) {
        self.selectedType = type
    }

    // Filter `filteredCharacters` array by search text.
    //Empty search text indicates all characters to be shown.
    func search(_ text: String) {
        searchText = text
        guard text.isEmpty == false else {
            filterCharacters()
            return
        }
        filteredCharacters = filteredCharacters.filter { containsSearchText(text: $0.name ?? "") }
        state = .success
    }
}

// MARK: API Calls
extension HomeViewModel {
    private func fetchCharacterList(offset: Int = 0, limit: Int) {
        guard isFetchingInProgress == false else { return }
        isFetchingInProgress = true

        let realmData = realmService.getData(of: Character.self)
        let characters = realmData.map { $0 } as [Character]
        if characters.count > offset {
            handleResponse(result: .success(characters))
            self.isFetchingInProgress = false
            print("Loaded from local")
            return
        }
        apiService.getAllCharacters(offset: offset, limit: limit) {[weak self] result in
            guard let self = self else { return }
            self.isFetchingInProgress = false
            print("Loaded from API")
            self.handleResponse(result: result)
        }
    }

    private func handleResponse(result: Result<[Character], Error>) {
        guard selectedType == .all else { return }
        switch result {
        case .success(let characters):
            self.characters.append(contentsOf: characters)
            self.realmService.writeData(objects: self.characters, updatePolicy: .all)
            state = .success
        case .failure(let error):
            self.delegate?.didUpdate(with: .error(error))
            state = .error(error)
            break
        }
    }
}
