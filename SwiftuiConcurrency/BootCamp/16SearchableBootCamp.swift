//
//  SearchableBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 17/12/24.
//

import SwiftUI
import Combine


struct Restaurant: Identifiable, Hashable {
    let id : String
    let title: String
    let cusine: CuisineOption
}

enum CuisineOption: String {
    case American
    case Italian
    case Indian
    case Japanese
    
}

final class RestaurantManager {
        
    func getAllRestaurants() async throws -> [Restaurant] {
        [
            Restaurant(id: "1", title: "Burger Shack", cusine: .American),
            Restaurant(id: "2", title: "Pasta Palace", cusine: .Italian),
            Restaurant(id: "3", title: "Masala Heaven", cusine: .Indian),
            Restaurant(id: "4", title: "Sushi World", cusine: .Japanese),
        ]
    }
}

@MainActor
final class SearchableViewModel: ObservableObject {
    
    @Published private(set) var allRestaurants: [Restaurant] = []
    @Published private(set) var filteredRestaurants: [Restaurant] = []
    
    @Published var searchText: String = ""
    @Published var searchScope: SearchScopeOption = .all
    @Published var allSearchScopes: [SearchScopeOption] = []
    
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    var showSearchSuggestion: Bool {
        searchText.count > 2
    }
    
    
    enum SearchScopeOption: Hashable {
        case all
        case cusine(option: CuisineOption)
        
        var title: String {
            switch self {
            case .all:
                return "All"
            case .cusine(let option):
                return option.rawValue.capitalized
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    
    let manager = RestaurantManager()
    
    func loadRestaurants() async {
        do {
            allRestaurants = try await manager.getAllRestaurants()
            let allCousines = Set(allRestaurants.map { $0.cusine })
            
            allSearchScopes = [.all] + allCousines.map { SearchScopeOption.cusine(option: $0) }
            
        } catch {
            debugPrint("Error :: \(error.localizedDescription)")
        }
    }
    
    private func addSubscribers() {
        $searchText
            .combineLatest($searchScope)
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] (searchText, searchScope) in
                self?.filterRestaurants(searchText: searchText, currScope: searchScope)
            }
            .store(in: &cancellables)
    }
    
    
    private func filterRestaurants(searchText: String, currScope: SearchScopeOption) {
        
        guard !searchText.isEmpty else {
            filteredRestaurants = []
            searchScope = .all
            return
        }
        
        // Filter on search scope
        var restaurantOnAllScope = allRestaurants
        
        switch currScope {
        case .all:
            break
        case .cusine(let option):
            restaurantOnAllScope = allRestaurants.filter { $0.cusine == option }
        }
        
        
        // Filter on search text
        let search = searchText.lowercased()
        filteredRestaurants = restaurantOnAllScope.filter { restaurnt in
            let titleContainsSearch = restaurnt.title.lowercased().contains(search)
            let cusineContainsSearch = restaurnt.cusine.rawValue.lowercased().contains(search)
            
            return titleContainsSearch || cusineContainsSearch
        }
    }
    
    func getSearchSuggestions() -> [String] {
    
        guard showSearchSuggestion else { return [] }
        
        var suggestions: [String] = []
        
        let search = searchText.lowercased()
        
        if search.contains("pa") {
            suggestions.append("pasta")
        }
        
        if search.contains("su") {
            suggestions.append("sushi")
        }
        
        if search.contains("bu") {
            suggestions.append("burger")
        }
        
        suggestions.append(CuisineOption.Italian.rawValue)
        suggestions.append(CuisineOption.American.rawValue)
        suggestions.append(CuisineOption.Indian.rawValue)
        suggestions.append(CuisineOption.Japanese.rawValue)
        
        
        return suggestions
    }
}


struct SearchableBootCamp: View {
    
    @StateObject private var vm = SearchableViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(vm.isSearching ? vm.filteredRestaurants : vm.allRestaurants) { restaurant in
                    NavigationLink(value: restaurant) {
                        restaurantRow(restaurant: restaurant)
                    }
                }
            }
//            SearchChildView()
        }
        .searchable(text: $vm.searchText, prompt: Text("Search restaurants..."))
        .searchScopes($vm.searchScope) {
            ForEach(vm.allSearchScopes, id: \.self) { searchScope in
                Text(searchScope.title)
                    .tag(searchScope)
            }
        }
        .searchSuggestions {
            ForEach(vm.getSearchSuggestions(), id: \.self) { suggestion in
                Text(suggestion)
                    .searchCompletion(suggestion)
            }
        }
        .navigationTitle("Restaurants")
        .navigationDestination(for: Restaurant.self) { restaurant in
            Text(restaurant.title.uppercased())
                .font(.headline)
        }
        .task {
            await vm.loadRestaurants()
        }
    }
}

extension SearchableBootCamp {
    
    private func restaurantRow(restaurant: Restaurant) -> some View {
        
        VStack(alignment: .leading) {
            Text(restaurant.title)
                .font(.headline)
                .foregroundStyle(.red)
            Text(restaurant.cusine.rawValue.capitalized)
                .font(.caption)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.black.opacity(0.05))
    }
}


#Preview {
    NavigationStack {
        SearchableBootCamp()
    }
}


struct SearchChildView: View {
    
    @Environment(\.isSearching) var isSearching
    
    
    var body: some View {
        Text("Child value is searching : \(isSearching)")
    }
}
