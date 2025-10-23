//
//  ViewController.swift
//  Randomizer
//
//  Created by Ақерке Амиртай on 22.10.2025.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var driverDescriptionLabel: UILabel!

    
    // MARK: - Data
    let drivers = [
        ("driver1", "Lando Norris #04", "Молодой талант из McLaren, всегда в борьбе и с чувством юмора."),
        ("driver2", "George Russell #63", "Спокойный и уверенный пилот Mercedes, мастер стабильности."),
        ("driver3", "Pierre Gasly #10", "Француз с сильным характером и техничным стилем вождения."),
        ("driver4", "Daniel Ricciardo #03", "Улыбка паддока и король обгонов, возвращающийся с драйвом."),
        ("driver5", "Yuki Tsunoda #22", "Энергичный японец, эмоциональный и быстрый на трассе."),
        ("driver6", "Alexander Albon #23", "Спокойный и умный стратег Williams с мягким стилем пилотирования."),
        ("driver7", "Valtteri Bottas #77", "Финский айсберг с мощным опытом и железным самообладанием."),
        ("driver8", "Fernando Alonso #14", "Легенда Формулы-1 — мудрый, хитрый и всё ещё невероятно быстрый."),
        ("driver9", "Carlos Sainz #55", "Испанец с холодной точностью и страстью к победе."),
        ("driver10", "Sergio Perez #11", "Мастер стратегии и бережного обращения с шинами."),
        ("driver11", "Charles Leclerc #16", "Эмоциональный монегаск Ferrari с чистой скоростью и амбицией."),
        ("driver12", "Lewis Hamilton #44", "Семикратный чемпион, символ упорства и лидерства."),
        ("driver13", "Max Verstappen #01", "Безжалостно быстрый чемпион, доминирующий в новой эре F1.")
    ]

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showRandomDriver()
    }

    // MARK: - UI Setup
    func setupUI() {
//        view.backgroundColor = UIColor.systemBackground
        
        driverImageView.layer.cornerRadius = 12
        randomizeButton.layer.cornerRadius = 14
        randomizeButton.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true

    }

    // MARK: - Actions
    @IBAction func randomizeButtonTapped(_ sender: UIButton) {
        showRandomDriver()
    }

    // MARK: - Logic
    func showRandomDriver() {
        let randomDriver = drivers.randomElement()!
        driverImageView.image = UIImage(named: randomDriver.0)
        driverNameLabel.text = randomDriver.1
        driverDescriptionLabel.text = randomDriver.2
    }
}


