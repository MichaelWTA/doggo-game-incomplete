//
//  DoggoButton.swift
//
//  Created by Intern on 3/11/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

final class DoggoButton: UIButton {

    var id: Int = 0
    private var tintView: UIView!
    private var nameLabel: UILabel!
    var answerState = AnswerState.unknown {
        didSet {
            switch answerState {
            case .unknown:
                hideAnswer()
            }
        }
    }

    // TODO: AnswerState
    enum AnswerState {
        case unknown
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        setTitleColor(.white, for: .normal)
        titleLabel?.alpha = 0.0

        let tintView = UIView(frame: self.bounds)
        tintView.alpha = 0.0
        tintView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tintView)

        tintView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tintView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tintView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tintView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        self.tintView = tintView
    }
    
    public func clearImage() {
        setBackgroundImage(nil, for: .normal)
    }

    public func loadImage(from url: String) {
        setBackgroundImage(nil, for: .normal)

        guard let imageURL = URL(string: url) else {
            preconditionFailure("Invalid image link")
        }

        URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) -> Void in
            guard let data = data else {
                return
            }

            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                self?.setBackgroundImage(image, for: .normal)
            }
        }).resume()
    }

    // TODO: showAnswer

    private func hideAnswer() {
        tintView.alpha = 0.0
        titleLabel?.alpha = 0.0
    }
}
