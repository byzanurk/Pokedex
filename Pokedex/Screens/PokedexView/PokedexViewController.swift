//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import UIKit

final class PokedexViewController: BaseViewController {
    
    // MARK:  Properties
    var coordinator: CoordinatorProtocol!
    var viewModel: PokedexViewModelProtocol!
    private var gridButton: UIBarButtonItem!
    private var sortButton: UIBarButtonItem!
    private var numberOfColumns: Int = 3    // default 3x3 grid
    
    // MARK:  Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK:  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokedex"
        viewModel.delegate = self
        setupCollectionView()
        setupNavButtons()
        fetchPokemons()
    }

    // MARK:  Setups
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
    
    private func setupNavButtons() {
        sortButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        
        gridButton = UIBarButtonItem(
            image: UIImage(systemName: "square.grid.4x3.fill"),
            style: .plain,
            target: self,
            action: #selector(gridButtonTapped)
        )
        
        sortButton.tintColor = .white
        gridButton.tintColor = .white
        
        navigationItem.rightBarButtonItems = [sortButton, gridButton]
    }
    
    // MARK:  Actions
    @objc private func sortButtonTapped() {
        print("sort button tapped")
        let sortMenu = SortMenuViewController(currentOption: viewModel.currentSortOption)
        sortMenu.delegate = self
        
        sortMenu.popoverPresentationController?.barButtonItem = sortButton
        sortMenu.popoverPresentationController?.delegate = self
        sortMenu.popoverPresentationController?.permittedArrowDirections = .up
        sortMenu.popoverPresentationController?.backgroundColor = .clear
        
        present(sortMenu, animated: true)
    }
    
    @objc private func gridButtonTapped() {
        print("grid button tapped")
        numberOfColumns = (numberOfColumns == 3) ? 4 : 3
        gridButton.image = UIImage(systemName: numberOfColumns == 3 ? "square.grid.4x3.fill" : "square.grid.3x3.fill")
        UIView.animate(withDuration: 0.3) {
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.layoutIfNeeded()
        }
    }
    
    // MARK: Data Fetch
    private func fetchPokemons() {
        viewModel.fetchPokemons()
    }
    

}

// MARK: - CollectionView
extension PokedexViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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


// MARK: - PokedexViewModelOutput
extension PokedexViewController: PokedexViewModelOutput {
    func didFetchPokemons() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showError(message: String) {
        print("Error: \(message)")
    }
}

// MARK: - SortMenuDelegate
extension PokedexViewController: SortMenuDelegate {
    func didSelectSortOption(_ option: SortOption) {
        viewModel.sortPokemons(by: option)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension PokedexViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

