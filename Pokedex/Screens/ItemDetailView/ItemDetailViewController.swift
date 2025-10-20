//  ItemDetailViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 19.10.2025.
//

import UIKit

class ItemDetailViewController: UIViewController {

    // MARK:  Properties
    var coordinator: CoordinatorProtocol!
    var viewModel: ItemDetailViewModelProtocol!
    
    // MARK:  Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.delegate = self
        viewModel.fetchItems()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .darkGrey
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemTableViewCell")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ItemDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Item: \(viewModel.items.first?.name ?? "-")")
        print("effectEntries: \(viewModel.items.first?.effectEntries ?? [])")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell,
              let items = viewModel?.items else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        let imageURL = URL(string: item.sprites?.defaultURL ?? "")
        
        // Subtitle öncelik: englishEffect -> shortEffect (en) -> effect (en) -> fallback
        let subtitle: String = {
            if let english = item.englishEffect, !english.isEmpty {
                return english
            }
            if let shortEn = item.effectEntries?.first(where: { $0.language.name.lowercased() == "en" })?.shortEffect, !shortEn.isEmpty {
                return shortEn
            }
            if let longEn = item.effectEntries?.first(where: { $0.language.name.lowercased() == "en" })?.effect, !longEn.isEmpty {
                return longEn
            }
            return "No effect available."
        }()

        cell.accessoryType = .none
        cell.configure(
            title: item.name?.capitalized ?? "-",
            iconURL: imageURL,
            subtitle: subtitle
        )
        cell.subtitleLabel.isHidden = false
        return cell
    }
}

extension ItemDetailViewController: ItemDetailViewModelOutput {
    func showError(message: String) {
        print("Error: \(message)")
    }
    
    func didUpdateItems() {
        tableView.reloadData()
    }
}
