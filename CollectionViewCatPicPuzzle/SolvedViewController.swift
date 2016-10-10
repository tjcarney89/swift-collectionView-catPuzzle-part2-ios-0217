//
//  SolvedViewController.swift
//  CollectionViewCats
//
//  Created by Joel Bell on 10/4/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class SolvedViewController: UIViewController {
    
    var time: String?
    var image: UIImage?
    
    var headerLabel: UILabel!
    var solvedTimeHeaderLabel: UILabel!
    var solvedTimeLabel: UILabel!
    var imageView: UIImageView!
    var backButton: UIButton!
    var verticalStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }
    
    func buttonTapped(sender: UIButton) {

        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SolvedViewController {
    
    func configureView() {
        
        addVerticalStackView()
        addHeaderLabel()
        addSolvedTimeHeaderLabel()
        addSolvedTimeLabel()
        addImageView()
        addBackButton()
        
    }
    
    private func addVerticalStackView() {
        
        verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .center
        
        self.view.addSubview(verticalStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        verticalStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
    }
    
    private func addHeaderLabel() {
        
        headerLabel = UILabel()
        headerLabel.text = "Puzzle Solved!"
        headerLabel.font = UIFont.helveticaNeueCondensedBold(size: 40)
        headerLabel.sizeToFit()
        
        verticalStackView.addArrangedSubview(headerLabel)
        
    }
    
    private func addSolvedTimeHeaderLabel() {
        
        solvedTimeHeaderLabel = UILabel()
        solvedTimeHeaderLabel.text = "Time:"
        solvedTimeHeaderLabel.font = UIFont.helveticaNeueBold(size: 20)
        solvedTimeHeaderLabel.sizeToFit()
        
        verticalStackView.addArrangedSubview(solvedTimeHeaderLabel)
        
    }
    
    private func addSolvedTimeLabel() {
        
        solvedTimeLabel = UILabel()
        solvedTimeLabel.text = time
        solvedTimeLabel.font = UIFont.helveticaNeueLight(size: 20)
        solvedTimeLabel.sizeToFit()
        
        verticalStackView.addArrangedSubview(solvedTimeLabel)
        
    }
    
    private func addImageView() {
            
        let imageTopSpacerView = UIView()
        verticalStackView.addArrangedSubview(imageTopSpacerView)
        
        imageTopSpacerView.translatesAutoresizingMaskIntoConstraints = false
        imageTopSpacerView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageTopSpacerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        verticalStackView.addArrangedSubview(imageView)
        
        if let image = image {
            
            let widthMultiplier = image.size.width / image.size.height
            imageView.image = image
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: widthMultiplier).isActive = true
            imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        }
        
        let imageBtmSpacerView = UIView()
        verticalStackView.addArrangedSubview(imageBtmSpacerView)
        
        imageBtmSpacerView.translatesAutoresizingMaskIntoConstraints = false
        imageBtmSpacerView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageBtmSpacerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    private func addBackButton() {
        
        backButton = UIButton()
        backButton.setTitle("BACK", for: .normal)
        backButton.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
        backButton.backgroundColor = UIColor.blue
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.layer.cornerRadius = 10
        
        verticalStackView.addArrangedSubview(backButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        backButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.065).isActive = true
        
    }
    
}
