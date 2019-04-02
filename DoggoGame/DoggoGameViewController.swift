//
//  ViewController.swift
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

final class DoggoGameViewController: UIViewController {

    @IBOutlet private var outerStackView: UIStackView!
    @IBOutlet private var innerStackView1: UIStackView!
    @IBOutlet private var innerStackView2: UIStackView!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var imageButtons: [DoggoButton]!

    private let doggoGame = DoggoGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doggoGame.delegate = self

        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doggoGame.loadGameData {
            DispatchQueue.main.async {
                self.doggoGame.startGame()
            }
        }
    }

    // TODO: doggoTapped

    private func setInteractionEnabled(_ value: Bool) {
        for button in imageButtons {
            button.isUserInteractionEnabled = value
        }
    }

    private func configureSubviews(_ orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            outerStackView.axis = .vertical
            innerStackView1.axis = .horizontal
            innerStackView2.axis = .horizontal
        } else {
            outerStackView.axis = .horizontal
            innerStackView1.axis = .vertical
            innerStackView2.axis = .vertical
        }

        view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation: UIDeviceOrientation = size.height > size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }
}

extension DoggoGameViewController: DoggoGameDelegate {
    func startNextRound() {
        questionLabel.text = doggoGame.questionForRound()

        for index in 0..<doggoGame.currentChoices.count where index < imageButtons.count {

            let imageButton = imageButtons[index]
            let profile = doggoGame.profileFor(choice: index)

            imageButton.answerState = .unknown


            API.getDogPicture(breedName: profile) { (dogURL: Headshot?, error: Error?) in
                guard let dogURL = dogURL, error == nil else {
                    NSLog("Failed to get list of people")
                    imageButton.clearImage()
                    return
                }
                imageButton.loadImage(from: dogURL.message)
                imageButton.setTitle(profile, for: UIControl.State())
                imageButton.id = index

                self.setInteractionEnabled(true)
            }
        }

    }}
