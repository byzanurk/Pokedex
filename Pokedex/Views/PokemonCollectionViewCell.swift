//
//  PokemonCollectionViewCell.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 13.10.2025.
//

import UIKit
import Kingfisher

final class PokemonCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        numberLabel.font = UIFont.pixel12
        numberLabel.textColor = .white
        
        nameLabel.font = UIFont.pixel12
        nameLabel.textColor = .white

        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageView.clipsToBounds = true
    }

    func configure(with pokemon: Pokemon) {
        numberLabel.text = "#\(String(format: "%03d", pokemon.id))"
        nameLabel.text = pokemon.name.capitalized
        
        print("Pokemon: \(pokemon.name), frontDefault: \(pokemon.sprite.frontDefault)")

        let imageUrl = URL(string: pokemon.sprite.frontDefault)
        if let imageUrl = imageUrl {
            pokemonImageView.kf.setImage(with: imageUrl) { [weak self] result in
                switch result {
                case .success(let value):
                    let dominantColor = value.image.dominantColor ?? UIColor.systemGray5
                    self?.containerView.backgroundColor = dominantColor.withAlphaComponent(0.85)
                case .failure:
                    self?.containerView.backgroundColor = UIColor.systemGray5
                    self?.pokemonImageView.image = UIImage(named: "PokeBall")
                }
            }
        } else {
            containerView.backgroundColor = UIColor.systemGray5
            pokemonImageView.image = UIImage(named: "PokeBall")
        }
    }
}
