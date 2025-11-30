//
//  ViewController.swift
//  HeroesApp
//
//  Created by Akerke Amirtay on 28.11.2025.
// 

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var intelligenceProgress: UIProgressView!
    @IBOutlet weak var intelligenceLabel: UILabel!

    @IBOutlet weak var strengthProgress: UIProgressView!
    @IBOutlet weak var strengthLabel: UILabel!

    @IBOutlet weak var speedProgress: UIProgressView!
    @IBOutlet weak var speedLabel: UILabel!

    @IBOutlet weak var powerProgress: UIProgressView!
    @IBOutlet weak var powerLabel: UILabel!

    @IBOutlet weak var combatProgress: UIProgressView!
    @IBOutlet weak var combatLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHeroes()
    }

    private func loadHeroes() {
        HeroService.shared.loadAll { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    if let hero = HeroService.shared.randomHero() {
                        self?.updateUI(hero)
                    }
                case .failure(let error):
                    print("Error:", error.localizedDescription)
                }
            }
        }
    }

    private func updateUI(_ hero: Hero) {
        nameLabel.text = hero.name

        // IMAGE
        let urlStr = hero.images.lg ?? hero.images.md ?? hero.images.sm
        if let urlStr = urlStr, let url = URL(string: urlStr) {
            heroImageView.kf.setImage(with: url)
        }

        func setStat(_ stat: Int?, progress: UIProgressView, label: UILabel) {
            let value = stat ?? 0
            label.text = "\(value)"
            progress.progress = Float(value) / 100
        }

        setStat(hero.powerstats.intelligence, progress: intelligenceProgress, label: intelligenceLabel)
        setStat(hero.powerstats.strength, progress: strengthProgress, label: strengthLabel)
        setStat(hero.powerstats.speed, progress: speedProgress, label: speedLabel)
        setStat(hero.powerstats.power, progress: powerProgress, label: powerLabel)
        setStat(hero.powerstats.combat, progress: combatProgress, label: combatLabel)
    }

    @IBAction func rollTapped(_ sender: Any) {
        if let hero = HeroService.shared.randomHero() {
            updateUI(hero)
        }
    }
}
