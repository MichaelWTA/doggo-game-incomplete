//
//  DoggoGame.swift
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation

protocol DoggoGameDelegate: class {
    func startNextRound()
}

final class DoggoGame {

    weak var delegate: DoggoGameDelegate?

    private let numberPeople = 6
    private var guessesLeft = 5
    private var dogs: [String] = []
    private var correctAnswer: String!
    var currentChoices: [String] = [String]()

    // Load JSON data from API
    func loadGameData(completion: @escaping () -> Void) {
        API.getDogs { (dogs: Profile?, error: Error?) in
            guard let dogs = dogs, error == nil else {
                NSLog("Failed to get list of people")
                return
            }

            self.dogs = dogs.message
            completion()
        }
    }

    func startGame() {
        createNewRound()
        delegate?.startNextRound()
    }

    private func createNewRound() {
        var currentChoiceIndexes = [Int]()
        currentChoices = [String]()
        guessesLeft = numberPeople
        for _ in 0..<numberPeople {

            var newPersonIndex = Int(arc4random_uniform(UInt32(dogs.count)))
            while currentChoiceIndexes.contains(newPersonIndex) {
                newPersonIndex = Int(arc4random_uniform(UInt32(dogs.count)))
            }

            currentChoiceIndexes.append(newPersonIndex)
            currentChoices.append(dogs[newPersonIndex])
        }

        correctAnswer = dogs[currentChoiceIndexes[Int(arc4random_uniform(UInt32(currentChoiceIndexes.count - 1)))]]
    }

    func questionForRound() -> String {
        return "Who is \(correctAnswer ?? "")?"
    }

    func profileFor(choice choiceIndex: Int) -> String {
        guard choiceIndex < currentChoices.count else {
            fatalError("The specified choice index is out of bounds")
        }

        return currentChoices[choiceIndex]
    }
    
    // TODO: checkAnswer
}
