//
//  ViewController.swift
//  HeroesApp
//
//  Created by Akerke Amirtay on 04.12.2025.
//

import UIKit
import Kingfisher

final class ViewController: UIViewController {

    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var durabilityLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var combatLabel: UILabel!
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    
    // NEW: activity indicator and random button outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var randomButton: UIButton!
    
    private let api = HeroAPI()
    
    // градиент, чтобы не создавать новый каждый раз
    private var gradientLayer: CAGradientLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        loadStoredHero()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradientOverlay()
    }
}

// MARK: - Loading state

private extension ViewController {
    func setLoading(_ loading: Bool) {
        randomButton.isEnabled = !loading
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Gradient

private extension ViewController {
    
    func setupGradientOverlay() {
        // если heroImage ещё не разложился по лэйауту — выходим
        guard heroImage.bounds.width > 0, heroImage.bounds.height > 0 else { return }
        
        // удаляем старый слой, чтобы не наслаивать
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        // от какого места начинать затемнение и до низа
        gradient.locations = [0.3, 0.7]
        gradient.frame = heroImage.bounds
        
        // кладём прямо на картинку, чтобы она затемнялась
        heroImage.layer.addSublayer(gradient)
        gradientLayer = gradient
    }
}

// MARK: - UI Setup

private extension ViewController {
    
    func updateHeroUI(_ hero: HeroModel) {
        heroName.text = formattedName(hero)
        weightLabel.text = hero.appearance.weight.last
        heightLabel.text = hero.appearance.height.last
        speedLabel.text = "\(hero.powerstats.speed)"
        durabilityLabel.text = "\(hero.powerstats.durability)"
        powerLabel.text = "\(hero.powerstats.power)"
        combatLabel.text = "\(hero.powerstats.combat)"
        intelligenceLabel.text = "\(hero.powerstats.intelligence)"
        strengthLabel.text = "\(hero.powerstats.strength)"
        
        if let url = URL(string: hero.images.lg) {
            heroImage.kf.setImage(with: url)
        } else {
            heroImage.image = nil
        }
    }
    
    func formattedName(_ hero: HeroModel) -> String {
        let genderSymbol: String = {
            switch hero.appearance.gender {
            case "Male": return "♂"
            case "Female": return "♀"
            default: return "⚲"
            }
        }()
        return "\(hero.name) \(genderSymbol)"
    }
}

// MARK: - Storage

private extension ViewController {
    
    func loadStoredHero() {
        guard
            let saved = UserDefaults.standard.data(forKey: "storedHero"),
            let hero = try? PropertyListDecoder().decode(HeroModel.self, from: saved)
        else { return }
        
        updateHeroUI(hero)
    }
    
    func storeHero(_ hero: HeroModel) {
        if let encoded = try? PropertyListEncoder().encode(hero) {
            UserDefaults.standard.set(encoded, forKey: "storedHero")
        }
    }
}

// MARK: - Actions

extension ViewController {
    
    @IBAction func rollButtonTapped(_ sender: Any) {
        Task { @MainActor in
            setLoading(true)
            defer { setLoading(false) } // гарантированно выключаем индикатор и разблокируем кнопку
            
            var loadedHero: HeroModel?
            
            repeat {
                let randomID = Int.random(in: 1...731)
                do {
                    loadedHero = try await api.getHero(id: randomID)
                } catch {
                    print("Ошибка загрузки: \(error)")
                    continue
                }
            } while loadedHero == nil
            
            guard let hero = loadedHero else { return }
            storeHero(hero)
            updateHeroUI(hero)
        }
    }
}
