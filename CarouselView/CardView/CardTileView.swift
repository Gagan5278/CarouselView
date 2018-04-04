//
//  file  : CardTileView.swift
//  bank42
//  Contents    : A subclass oh UIView. Will be used in Card module whenever applicable.
//  Created by Sharat on 02/04/18.
//  Copyright © 2018 Gagan Vishal. All rights reserved.
//

import UIKit


@IBDesignable

class CardTileView: UIView {
    
    @IBOutlet var cardView: UIView!
    @IBOutlet weak var cardNameLabel: UILabel!  //Label to display name of the card in String format
    @IBOutlet weak var cardTypeLabel: UILabel!   //Label to show card type. Aerican Express, Visa, Master card
    @IBOutlet weak var cardNumberLabel: UILabel! //Label to reprset card  number : Number/Digit
    @IBOutlet weak var cardStatusLabel: UILabel! //Cars status label: String -- types 1. ACTIVE 2. INACTIVE
    
    /*
     IBInspectable allows to real time UI modification in storyboard or in XIB.
     -- Set corner radius from implemented XIB or Storyborad.Initial state in zero
     */
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    /*
     --Set corner border color from implemented XIB or Storyborad.Initial state in clear color
     */
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
    }
    
    //MARK:-
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()
    {
        Bundle.main.loadNibNamed("CardTileView", owner: self, options: nil)
        //Set cardView frame to origin of superview and same size o of it's superview
        self.cardView.frame = self.frame
        self.cardView.frame.origin.x = 0.0
        self.cardView.frame.origin.y = 0.0
        //add cardView to CardTileView
        addSubview(self.cardView)
        self.cardView.setNeedsLayout()
        self.cardView.layoutIfNeeded()
        //In case a large amount of text availbale. Decrease the font size to fit in available area of UILabel
        self.cardNameLabel.adjustsFontSizeToFitWidth = true
        self.cardNameLabel.minimumScaleFactor=0.5
    }
}
