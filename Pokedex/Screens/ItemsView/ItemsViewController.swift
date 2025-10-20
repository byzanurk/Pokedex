//
//  ItemsViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import UIKit
import Kingfisher

final class ItemsViewController: BaseViewController {

    // MARK:  Properties
    var coordinator: CoordinatorProtocol!
    var viewModel: ItemsViewModelProtocol!
    private var categoryIconCache: [String: URL] = [:]
    private var inFlightIconFetch: Set<String> = []
    
    // MARK:  Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK:  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Items"
        view.backgroundColor = .darkGrey
        viewModel.delegate = self
        setupTableView()
        fetchCategories()
    }
    
    // MARK:  Setup
    private func setupTableView() {
        tableView.backgroundColor = .darkGrey
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(
            UINib(nibName: "ItemTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ItemTableViewCell"
        )
    }
    
    // MARK:  Data Fetching
    private func fetchCategories() {
        viewModel.fetchCategories()
    }
    
    // MARK:  Icon Fetching and Caching
    private func fetchIconURL(forCategory name: String, tryFirst count: Int = 5, completion: @escaping (URL?) -> Void) {
        viewModel.fetchCategoryDetail(name: name) { [weak self] result in
            guard let self else { completion(nil); return }
            switch result {
            case .success(let detail):
                let items = Array(detail.items.prefix(count))
                guard !items.isEmpty else { completion(nil); return }
                
                func tryNext(_ index: Int) {
                    guard index < items.count else { completion(nil); return }
                    let itemName = items[index].name
                    print("fetching item detail for icon (try \(index+1)/\(items.count)): \(itemName)")
                    self.viewModel.fetchItemDetail(name: itemName) { [weak self] itemResult in
                        guard let self else { return }
                        switch itemResult {
                        case .success(let itemDetail):
                            if let urlString = itemDetail.sprites?.defaultURL, let url = URL(string: urlString) {
                                completion(url)
                            } else {
                                tryNext(index + 1)
                            }
                        case .failure:
                            tryNext(index + 1)
                        }
                    }
                }
                tryNext(0)
            case .failure:
                completion(nil)
            }
        }
    }
    
    private func loadIconIfNeeded(for indexPath: IndexPath) {
        guard viewModel.categories.indices.contains(indexPath.row) else { return }
        let category = viewModel.categories[indexPath.row]
        let key = category.name
        if categoryIconCache[key] != nil || inFlightIconFetch.contains(key) { return }
        
        inFlightIconFetch.insert(key)
        fetchIconURL(forCategory: key, tryFirst: 5) { [weak self] url in
            guard let self else { return }
            self.inFlightIconFetch.remove(key)
            guard let url else {
                print("no icon found for category: \(key) (after trying first 5 items)")
                return
            }
            self.categoryIconCache[key] = url
            print("icon cached for \(key): \(url.absoluteString)")
            if let visibleIndex = self.viewModel.categories.firstIndex(where: { $0.name == key }) {
                let idx = IndexPath(row: visibleIndex, section: 0)
                if self.tableView.indexPathsForVisibleRows?.contains(idx) == true {
                    self.tableView.reloadRows(at: [idx], with: .fade)
                }
            }
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell
        else { return UITableViewCell() }
        
        let category = viewModel.categories[indexPath.row]
        let title = category.name.replacingOccurrences(of: "-", with: " ").capitalized
        
        if let url = categoryIconCache[category.name] {
            cell.configure(title: title, iconURL: url, subtitle: nil)
        } else {
            cell.configure(title: title, iconURL: nil, subtitle: nil)
            loadIconIfNeeded(for: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = viewModel.categories[indexPath.row]
        let itemDetailVC = ItemDetailViewBuilder.build(coordinator: coordinator, selectedCategory: selectedCategory)
        navigate(to: itemDetailVC, coordinator: coordinator)
    }
}

// MARK: - ItemsViewModelOutput
extension ItemsViewController: ItemsViewModelOutput {
    func didLoadCategories() {
        categoryIconCache.removeAll()
        inFlightIconFetch.removeAll()
        tableView.reloadData()
    }
    
    func showError(message: String) {
        print("Items error: \(message)")
    }
}

