//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 14.10.2025.
//

import UIKit
import Kingfisher

class PokemonDetailViewController: UIViewController {

    // MARK:  Properties
    var coordinator: CoordinatorProtocol!
    var viewModel: PokemonDetailViewModelProtocol!
    var selectedPokemon: Pokemon?
    
    private var isShowingFrontImage: Bool = true
    private var isBookmarked: Bool = false
    
    // MARK: Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var backgroundColorView: UIView!
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var typesTitleLabel: UILabel!
    @IBOutlet private weak var typesValueLabel: UILabel!
    @IBOutlet private weak var heightTitleLabel: UILabel!
    @IBOutlet private weak var heightValueLabel: UILabel!
    @IBOutlet private weak var weightTitleLabel: UILabel!
    @IBOutlet private weak var weightValueLabel: UILabel!
    @IBOutlet private weak var abilitiesTitleLabel: UILabel!
    @IBOutlet private weak var abilitiesValueLabel: UILabel!
    @IBOutlet private weak var speedTitleLabel: UILabel!
    @IBOutlet private weak var speedProgressView: UIProgressView!
    @IBOutlet private weak var speedValueLabel: UILabel!
    @IBOutlet private weak var specialDefenseTitleLabel: UILabel!
    @IBOutlet private weak var specialDefenseProgressView: UIProgressView!
    @IBOutlet private weak var specialDefenseValueLabel: UILabel!
    @IBOutlet private weak var specialAttackTitleLabel: UILabel!
    @IBOutlet private weak var specialAttackProgressView: UIProgressView!
    @IBOutlet private weak var specialAttackValueLabel: UILabel!
    @IBOutlet private weak var defenseTitleLabel: UILabel!
    @IBOutlet private weak var defenseProgressView: UIProgressView!
    @IBOutlet private weak var defenseValueLabel: UILabel!
    @IBOutlet private weak var hpTitleLabel: UILabel!
    @IBOutlet private weak var hpProgressView: UIProgressView!
    @IBOutlet private weak var hpValueLabel: UILabel!
    @IBOutlet private weak var attackTitleLabel: UILabel!
    @IBOutlet private weak var attackProgressView: UIProgressView!
    @IBOutlet private weak var attackValueLabel: UILabel!
    @IBOutlet private weak var movesTitleLabel: UILabel!
    @IBOutlet private weak var movesValueLabel: UILabel!
    
    @IBOutlet private weak var flipButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGrey
        containerView.backgroundColor = .darkGrey
        
        viewModel.delegate = self
        setupLabelsAppearance()
        setupButtonsAppearance()
        
        if let pokemon = selectedPokemon {
            viewModel.selectedPokemon = pokemon
            bindUI(with: pokemon)
        } else {
            viewModel.fetchPokemonDetail()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreGlobalNavigationBarAppearance()
    }
    
    // MARK: - Appearance
    private func setupLabelsAppearance() {
        let allLabels: [UILabel?] = [
            typesTitleLabel, typesValueLabel,
            heightTitleLabel, heightValueLabel,
            weightTitleLabel, weightValueLabel,
            abilitiesTitleLabel, abilitiesValueLabel,
            speedTitleLabel, speedValueLabel,
            specialDefenseTitleLabel, specialDefenseValueLabel,
            specialAttackTitleLabel, specialAttackValueLabel,
            defenseTitleLabel, defenseValueLabel,
            hpTitleLabel, hpValueLabel,
            attackTitleLabel, attackValueLabel,
            movesTitleLabel, movesValueLabel
        ]
        allLabels.forEach { $0?.font = .pixel14 }
        
        let titleLabels: [UILabel?] = [
            typesTitleLabel,
            heightTitleLabel,
            weightTitleLabel,
            abilitiesTitleLabel,
            speedTitleLabel,
            specialDefenseTitleLabel,
            specialAttackTitleLabel,
            defenseTitleLabel,
            hpTitleLabel,
            attackTitleLabel,
            movesTitleLabel
        ]
        titleLabels.forEach { $0?.textColor = .systemGray }
        
        let valueLabels: [UILabel?] = [
            typesValueLabel,
            heightValueLabel,
            weightValueLabel,
            abilitiesValueLabel,
            speedValueLabel,
            specialDefenseValueLabel,
            specialAttackValueLabel,
            defenseValueLabel,
            hpValueLabel,
            attackValueLabel,
            movesValueLabel
        ]
        valueLabels.forEach { $0?.textColor = .white }
    }
    
    private func setupButtonsAppearance() {
        let flipConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let flipImage = UIImage(systemName: "arrow.trianglehead.2.counterclockwise", withConfiguration: flipConfig)
        flipButton.setImage(flipImage, for: .normal)
        flipButton.tintColor = .white
        
        let bookmarkConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let bookmarkImage = UIImage(systemName: "bookmark", withConfiguration: bookmarkConfig)
        favoriteButton.setImage(bookmarkImage, for: .normal)
        favoriteButton.tintColor = .white
    }
    
    // MARK: - Binding
    private func bindUI(with pokemon: Pokemon) {
        setupNavigationTitle(with: pokemon)
        fillLabels(with: pokemon)
        loadImageAndApplyNavBar(with: pokemon, useFront: true)
    }
    
    private func setupNavigationTitle(with pokemon: Pokemon) {
        let number = "#\(String(format: "%03d", pokemon.id))"
        let name = pokemon.name.capitalized
        navigationItem.title = "\(number) \(name)"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func fillLabels(with pokemon: Pokemon) {
        typesTitleLabel.text = "Types"
        heightTitleLabel.text = "Height"
        weightTitleLabel.text = "Weight"
        abilitiesTitleLabel.text = "Abilities"
        speedTitleLabel.text = "Speed"
        specialDefenseTitleLabel.text = "Special Defense"
        specialAttackTitleLabel.text = "Special Attack"
        defenseTitleLabel.text = "Defense"
        hpTitleLabel.text = "HP"
        attackTitleLabel.text = "Attack"
        movesTitleLabel.text = "Moves"
        
        typesValueLabel.text = pokemon.types?.map { $0.type.name.capitalized }.joined(separator: ", ") ?? "-"
        if let height = pokemon.height {
            heightValueLabel.text = String(format: "%.1f m", Double(height) / 10.0)
        } else {
            heightValueLabel.text = "-"
        }
        if let weight = pokemon.weight {
            weightValueLabel.text = String(format: "%.1f kg", Double(weight) / 10.0)
        } else {
            weightValueLabel.text = "-"
        }
        abilitiesValueLabel.text = pokemon.abilities?.map { $0.ability.name.capitalized }.joined(separator: ", ") ?? "-"
        movesValueLabel.text = pokemon.moves?.map { $0.move.name.capitalized }.joined(separator: ", ") ?? "-"
        
        let statsByName: [String: Int] = Dictionary(uniqueKeysWithValues:
            (pokemon.stats ?? []).map { ($0.stat.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), $0.baseStat) }
        )
        
        let hp = statsByName["hp"] ?? 0
        let attack = statsByName["attack"] ?? 0
        let defense = statsByName["defense"] ?? 0
        let speed = statsByName["speed"] ?? 0
        let specialAttack = statsByName["special-attack"] ?? 0
        let specialDefense = statsByName["special-defense"] ?? 0
        
        func normalize(_ value: Int) -> Int {
            Int((Float(value) / 255.0) * 100.0)
        }
        
        let normalizedHP = normalize(hp)
        let normalizedAttack = normalize(attack)
        let normalizedDefense = normalize(defense)
        let normalizedSpeed = normalize(speed)
        let normalizedSpecialAttack = normalize(specialAttack)
        let normalizedSpecialDefense = normalize(specialDefense)

        hpValueLabel.text = "\(normalizedHP)/100"
        attackValueLabel.text = "\(normalizedAttack)/100"
        defenseValueLabel.text = "\(normalizedDefense)/100"
        speedValueLabel.text = "\(normalizedSpeed)/100"
        specialAttackValueLabel.text = "\(normalizedSpecialAttack)/100"
        specialDefenseValueLabel.text = "\(normalizedSpecialDefense)/100"

        hpProgressView.progress = Float(normalizedHP) / 100.0
        attackProgressView.progress = Float(normalizedAttack) / 100.0
        defenseProgressView.progress = Float(normalizedDefense) / 100.0
        speedProgressView.progress = Float(normalizedSpeed) / 100.0
        specialAttackProgressView.progress = Float(normalizedSpecialAttack) / 100.0
        specialDefenseProgressView.progress = Float(normalizedSpecialDefense) / 100.0
        
        let dominantColor = backgroundColorView.backgroundColor ?? .systemGray5
        [
            specialAttackProgressView,
            specialDefenseProgressView,
            hpProgressView,
            attackProgressView,
            defenseProgressView,
            speedProgressView
        ].forEach { $0?.progressTintColor = dominantColor }
    }
    
    private func loadImageAndApplyNavBar(with pokemon: Pokemon, useFront: Bool) {
        pokemonImageView.contentMode = .scaleAspectFit
        isShowingFrontImage = useFront

        let urlString = useFront ? pokemon.sprite.frontDefault : pokemon.sprite.backDefault
        if let imageUrl = URL(string: urlString) {
            pokemonImageView.kf.setImage(with: imageUrl) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    let dominant = value.image.dominantColor ?? UIColor.systemGray5
                    self.backgroundColorView.backgroundColor = dominant.withAlphaComponent(0.85)
                    self.applyNavigationBar(color: dominant)
                case .failure:
                    let fallback = UIColor.systemGray5
                    self.backgroundColorView.backgroundColor = fallback
                    self.applyNavigationBar(color: fallback)
                }
            }
        } else {
            pokemonImageView.image = UIImage(named: "PokeBall")
            let fallback = UIColor.systemGray5
            backgroundColorView.backgroundColor = fallback
            applyNavigationBar(color: fallback)
        }
    }
    
    // MARK: - Actions
    @IBAction func flipButtonTapped(_ sender: Any) {
        guard let pokemon = viewModel.selectedPokemon ?? selectedPokemon else { return }
        let nextIsFront = !isShowingFrontImage
        let options: UIView.AnimationOptions = nextIsFront ? .transitionFlipFromLeft : .transitionFlipFromRight
        UIView.transition(with: pokemonImageView, duration: 0.5, options: [options, .showHideTransitionViews]) {
            self.loadImageAndApplyNavBar(with: pokemon, useFront: nextIsFront)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        isBookmarked.toggle()
        let symbolName = isBookmarked ? "bookmark.fill" : "bookmark"
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        favoriteButton.setImage(UIImage(systemName: symbolName, withConfiguration: config), for: .normal)
        favoriteButton.tintColor = isBookmarked ? .systemGray4 : .white
    }
    
    // MARK: - Navigation Bar Appearance (local)
    private func applyNavigationBar(color: UIColor) {
        guard let navBar = navigationController?.navigationBar else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        appearance.backgroundColor = color.withAlphaComponent(0.6)
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
            .font: UIFont.pixel14
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont.pixel14
        ]
        
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.isTranslucent = true
    }
    
    // MARK: - Restore Global Appearance
    private func restoreGlobalNavigationBarAppearance() {
        guard let navBar = navigationController?.navigationBar else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .pokedexRed
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.pixel17
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.pixel17
        ]
        
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.tintColor = .white
        navBar.isTranslucent = false
    }
}

// MARK: - PokemonDetailViewModelOutput
extension PokemonDetailViewController: PokemonDetailViewModelOutput {
    func didLoadPokemon(_ pokemon: Pokemon) {
        isBookmarked = false
        bindUI(with: pokemon)
    }
    
    func showError(message: String) {
        print("Detail error: \(message)")
    }
}
