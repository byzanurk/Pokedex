//
//  SearchViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 13.10.2025.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    var coordinator: CoordinatorProtocol!
    var viewModel: SearchViewModelProtocol!

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyStateView: UIView!
    @IBOutlet private weak var emptyStateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        emptyStateView.isHidden = false
        searchBar.delegate = self
        viewModel.delegate = self
        setupSearchBarAppearance()
        setupCollectionView()
        fetchPokemons()
        updateEmptyState()
    }
    
    private func setupSearchBarAppearance() {
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .darkGrey
        searchBar.isTranslucent = true
        searchBar.backgroundColor = .darkGrey
        searchBar.placeholder = "Search Pokemon"
        
        emptyStateLabel.font = UIFont.pixel14
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = .clear
        textField.textColor = .label
        textField.attributedPlaceholder = NSAttributedString(
            string: searchBar.placeholder ?? "",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel,
                .font: UIFont.pixel14
            ]
        )
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.darkGrey
        collectionView.register(
            UINib(nibName: "PokemonCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "PokemonCollectionViewCell"
        )
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
    }
    
    private func fetchPokemons() {
        viewModel.fetchAllPokemons()
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.pokemons.isEmpty
        emptyStateView.isHidden = !isEmpty
    }
}

// MARK: - SearchBar Extension
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            viewModel.pokemons = []
        } else {
            viewModel.pokemons = viewModel.allPokemons.filter {
                $0.name.localizedCaseInsensitiveContains(trimmed)
            }
        }
        collectionView.reloadData()
        updateEmptyState()
    }
}

// MARK: - CollectionView Extension
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionViewCell", for: indexPath) as! PokemonCollectionViewCell
        let pokemon = viewModel.pokemons[indexPath.row]
        cell.configure(with: pokemon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = viewModel.pokemons[indexPath.row]
        let pokemonDetailVC = PokemonDetailViewBuilder.build(coordinator: coordinator, selectedPokemon: selectedPokemon)
        navigate(to: pokemonDetailVC, coordinator: coordinator)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset: CGFloat = 2
        let spacing: CGFloat = 2
        let numberOfColumns: Int = 3  // default 3x3 grid
        
        let totalHorizontalSpacing = inset * 2 + spacing * CGFloat(numberOfColumns - 1)
        let availableWidth = collectionView.bounds.width - totalHorizontalSpacing
        let width = floor(availableWidth / CGFloat(numberOfColumns))
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

// MARK: - SearchViewModelOutput
extension SearchViewController: SearchViewModelOutput {
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updateEmptyState()
        }
    }
    
    func showError(message: String) {
        print("Error: \(message)")
    }
}
