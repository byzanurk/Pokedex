//
//  FavouritesViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import UIKit

final class FavouritesViewController: BaseViewController {
    
    // MARK:  Properties
    var coordinator: CoordinatorProtocol!
    var viewModel: FavouritesViewModelProtocol!
    
    // MARK:  Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK:  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourites"
        viewModel.delegate = self
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavourites()
    }
    
    // MARK:  Setup
    private func setupCollectionView() {
        collectionView.backgroundColor = .darkGrey
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PokemonCollectionViewCell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
    }

}

// MARK: - CollectionView Delegate & DataSource
extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let numberOfColumns: Int = 3
    
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

// MARK: - FavouritesViewModelOutput
extension FavouritesViewController: FavouritesViewModelOutput {
    func didFetchFavourites() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showError(message: String) {
        print("Error: \(message)")
    }
}
