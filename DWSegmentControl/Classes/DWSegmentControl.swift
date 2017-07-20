//
//  DWSegmentControl.swift
//  DWSegmentControl
//
//  Created by Dawson Walker on 2017-07-20.
//  Copyright © 2017 Dawson Walker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class DWSegmentControl: UIView  {
    
    @IBInspectable var titleFont: UIFont = UIFont(name: "Helvetica", size: 15)! {
        didSet {
            self.rightButton.titleLabel?.font = titleFont
            self.leftButton.titleLabel?.font = titleFont
            self.middleButton.titleLabel?.font = titleFont
        }
    }
    @IBInspectable var disableColor: UIColor = UIColor.gray {
        didSet {
            self.disabledColor = disableColor
        }
    }
    @IBInspectable var enableColor: UIColor = UIColor.black {
        didSet {
            self.enabledColor = enableColor
        }
    }
    @IBInspectable var initialIndex: Int = 0 {
        didSet {
            self.currentIndex = initialIndex
            self.currentIndexVariable.value = initialIndex
            self.setCurrentIndex(index: initialIndex)
            self.setInitialIndex(index: initialIndex)
        }
    }
    @IBInspectable var imageEnabled: Bool = false {
        didSet {
            self.hasImage = imageEnabled
        }
    }
    @IBInspectable var leftImage: UIImage? {
        didSet {
            self.firstImage = leftImage
        }
    }
    @IBInspectable var middleImage: UIImage? {
        didSet {
            self.secondImage = middleImage
        }
    }
    @IBInspectable var rightImage: UIImage? {
        didSet {
            self.thirdImage = rightImage
        }
    }
    
    @IBInspectable var leftText: String = "" {
        didSet {
            self.leftButton.setTitle(leftText, for: .normal)
        }
    }
    @IBInspectable var middleText: String = "" {
        didSet {
            self.middleButton.setTitle(middleText, for: .normal)
        }
    }
    @IBInspectable var rightText: String = "" {
        didSet {
            self.rightButton.setTitle(rightText, for: .normal)
        }
    }
    
    
    public var enabledColor = UIColor.black
    public var disabledColor = UIColor.gray
    public var currentIndex = 0
    public var hasImage = false
    public var currentIndexVariable = Variable(Int())
    public var firstImage: UIImage?
    public var secondImage: UIImage?
    public var thirdImage: UIImage?
    public var disabledFirstImage: UIImage?
    public var disabledSecondImage: UIImage?
    public var disabledThirdImage: UIImage?
    
    @IBOutlet weak var colorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingColorConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingColorConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var middleButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rightButton.titleLabel!.numberOfLines = 1;
        rightButton.titleLabel!.adjustsFontSizeToFitWidth = true;
        rightButton.titleLabel!.lineBreakMode = .byClipping;
        leftButton.titleLabel!.numberOfLines = 1;
        leftButton.titleLabel!.adjustsFontSizeToFitWidth = true;
        leftButton.titleLabel!.lineBreakMode = .byClipping;
        middleButton.titleLabel!.numberOfLines = 1;
        middleButton.titleLabel!.adjustsFontSizeToFitWidth = true;
        middleButton.titleLabel!.lineBreakMode = .byClipping;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = Bundle.main.loadNibNamed("DWSegmentControl", owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        rightButton.titleLabel!.numberOfLines = 1;
        rightButton.titleLabel!.adjustsFontSizeToFitWidth = true;
        rightButton.titleLabel!.lineBreakMode = .byClipping;
        leftButton.titleLabel!.numberOfLines = 1;
        leftButton.titleLabel!.adjustsFontSizeToFitWidth = true;
        leftButton.titleLabel!.lineBreakMode = .byClipping;
        middleButton.titleLabel!.numberOfLines = 1;
        middleButton.titleLabel!.adjustsFontSizeToFitWidth = true;
        middleButton.titleLabel!.lineBreakMode = .byClipping;
        
    }
    
    func changeIndex(index: Int) {
        self.setCurrentIndex(index: index)
        self.changeUnderline(index: index)
    }
    
    func setInitialIndex(index: Int) {
        self.setCurrentIndex(index: index)
        self.changeUnderline(index: index)
        if index == 0 {
            self.changeButtonColor(enabledButton: self.leftButton, disabledButtons: [self.rightButton, self.middleButton])
        } else if index == 1 {
            self.changeButtonColor(enabledButton: self.middleButton, disabledButtons: [self.rightButton, self.leftButton])
        } else if index == 2 {
            self.changeButtonColor(enabledButton: self.rightButton, disabledButtons: [self.leftButton, self.middleButton])
        }
    }
    func changeUnderline(index: Int) {
        if index == 0 {
            if hasImage {
                self.leftButton.setImage(firstImage!.withRenderingMode(.alwaysOriginal), for: .normal)
                self.rightButton.setImage(disabledThirdImage!.withRenderingMode(.alwaysOriginal), for: .normal)
                self.middleButton.setImage(disabledSecondImage!.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
            self.changeButtonColor(enabledButton: self.leftButton, disabledButtons: [self.rightButton, self.middleButton])
            let widthOfText = self.getFontWidthOfButton(button: self.leftButton)
            let offset = (self.frame.size.width/3 - widthOfText)/2
            UIView.animate(withDuration: 0.15, animations: {
                self.leadingColorConstraint.constant = offset
                self.trailingColorConstraint.constant = (self.frame.size.width/3 * 2) + offset
                self.layoutIfNeeded()
            })
        } else if index == 1 {
            if hasImage {
                self.leftButton.setImage(disabledFirstImage!.withRenderingMode(.alwaysOriginal), for: .normal)
                self.rightButton.setImage(disabledThirdImage!.withRenderingMode(.alwaysOriginal), for: .normal)
                self.middleButton.setImage(secondImage!.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            self.changeButtonColor(enabledButton: self.middleButton, disabledButtons: [self.rightButton, self.leftButton])
            let widthOfText = self.getFontWidthOfButton(button: self.middleButton)
            let offset = (self.frame.size.width/3 - widthOfText)/4
            UIView.animate(withDuration: 0.15, animations: {
                self.leadingColorConstraint.constant = self.frame.size.width/3 + offset + 12
                self.trailingColorConstraint.constant = self.frame.size.width/3 + offset + 12
                self.layoutIfNeeded()
            })
        } else if index == 2 {
            if hasImage {
                self.leftButton.setImage(disabledFirstImage!.withRenderingMode(.alwaysOriginal), for: .normal)
                self.rightButton.setImage(thirdImage!.withRenderingMode(.alwaysOriginal), for: .normal)
                self.middleButton.setImage(disabledSecondImage!.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            self.changeButtonColor(enabledButton: self.rightButton, disabledButtons: [self.leftButton, self.middleButton])
            let widthOfText = self.getFontWidthOfButton(button: self.rightButton)
            let offset = (self.frame.size.width/3 - widthOfText)/4
            UIView.animate(withDuration: 0.15, animations: {
                self.leadingColorConstraint.constant = self.frame.size.width/3 * 2 + offset
                self.trailingColorConstraint.constant = 0 + offset
                self.layoutIfNeeded()
            })
        }
    }
    func changeButtonColor(enabledButton: UIButton, disabledButtons: [UIButton]) {
        enabledButton.setTitleColor(enabledColor, for: .normal)
        
        for button in disabledButtons {
            button.setTitleColor(disabledColor, for: .normal)
        }
        
    }
    func setCurrentIndex(index: Int) {
        
        self.currentIndex = index
        self.currentIndexVariable.value = index
        
    }
    func getFontWidthOfButton(button: UIButton) -> CGFloat{
        if !hasImage {
            let string = button.titleLabel!.intrinsicContentSize
            return string.width
        } else {
            return self.frame.size.width/3
        }
        
    }
    @IBAction func buttonPressed(_ sender: Any) {
        let object = sender as! UIButton
        self.setCurrentIndex(index: object.tag)
        self.changeUnderline(index: object.tag)
    }
    
}

    

