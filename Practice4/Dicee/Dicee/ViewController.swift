//
//  ViewController.swift
//  Dicee
//
//  Created by Ақерке Амиртай on 17.10.2025.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lhsDice: UIImageView!
    @IBOutlet weak var rhsDice: UIImageView!
    @IBOutlet weak var rollButton: UIButton!

    let diceImages: [UIImage] = [ #imageLiteral(resourceName: "Dice1"), #imageLiteral(resourceName: "Dice2"), #imageLiteral(resourceName: "Dice3"), #imageLiteral(resourceName: "Dice4"), #imageLiteral(resourceName: "Dice5"), #imageLiteral(resourceName: "Dice6") ]
    let diceImagesEnum: [UIImage] = [
        .dice1, .dice2, .dice3, .dice4, .dice5, .dice6    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        lhsDice.image = #imageLiteral(resourceName: "Dice3")
        rhsDice.image = #imageLiteral(resourceName: "Dice4")
        rollButton.layer.cornerRadius = 16
//        rollButton.backgroundColor = .systemTeal
    }

    @IBAction func rollButtonDidTap(_ sender: UIButton) {
        // 🎲 Перед сменой изображений — анимация вращения
        UIView.animate(withDuration: 0.3, animations: {
            self.lhsDice.transform = CGAffineTransform(rotationAngle: .pi)
            self.rhsDice.transform = CGAffineTransform(rotationAngle: -.pi)
            self.lhsDice.alpha = 0.5
            self.rhsDice.alpha = 0.5
        }) { _ in
            // После анимации — устанавливаем новые изображения
            self.lhsDice.image = self.diceImages.randomElement()
            self.rhsDice.image = self.diceImages.randomElement()

            // Возвращаем исходное состояние плавно
            UIView.animate(withDuration: 0.3) {
                self.lhsDice.transform = .identity
                self.rhsDice.transform = .identity
                self.lhsDice.alpha = 1.0
                self.rhsDice.alpha = 1.0
            }
        }
    }
}
