//
//  ViewController.swift
//  Imagebox
//
//  Created by feodor on 16/10/17.
//  Copyright © 2017 feodor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    
    //When creating a UIButton in Interface Builder, ensure the Button Type is "Custom" and size constraints are "Greater Than or Equal"
    @IBAction func showButtonOne(_ sender: UIButton) {
        if let image = UIImage(named: imageOneName) {
            let controller = ImageboxController(image: image)
            controller.modalPresentationStyle = .overFullScreen
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func showButtonTwo(_ sender: UIButton) {
        if let image = UIImage(named: imageTwoName) {
            let controller = ImageboxController(image: image)
            controller.modalPresentationStyle = .overFullScreen
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var buttonOneHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonOneWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonTwoHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonTwoWidth: NSLayoutConstraint!
    
    private let imageOneName = "flowers"
    private let imageTwoName = "mountains"
    //This dimension sets the maximum for width or height of your image in the ViewController
    private let imageMaxDimension:CGFloat = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageOne = UIImage(named: imageOneName){
            let aspectRatio = imageOne.size.width / imageOne.size.height
            if aspectRatio > 1.0 {
                buttonOneWidth.constant = imageMaxDimension
                buttonOneHeight.constant = floor(imageMaxDimension / aspectRatio)
            }
            else {
                buttonOneWidth.constant = floor(imageMaxDimension * aspectRatio)
                buttonOneHeight.constant = imageMaxDimension
            }
            buttonOne.frame.size = CGSize(width: buttonOneWidth.constant, height: buttonOneHeight.constant)
            buttonOne.setImage(imageOne.resizedImageWithinRect(rectSize: buttonOne.frame.size), for: .normal)
            buttonOne.titleLabel?.text = nil
        }
        
        if let imageTwo = UIImage(named: imageTwoName){
            let aspectRatio = imageTwo.size.width / imageTwo.size.height
            if aspectRatio > 1.0 {
                buttonTwoWidth.constant = imageMaxDimension
                buttonTwoHeight.constant = floor(imageMaxDimension / aspectRatio)
            }
            else {
                buttonTwoWidth.constant = floor(imageMaxDimension * aspectRatio)
                buttonTwoHeight.constant = imageMaxDimension
            }
            buttonTwo.frame.size = CGSize(width: buttonTwoWidth.constant, height: buttonTwoHeight.constant)
            buttonTwo.setImage(imageTwo.resizedImageWithinRect(rectSize: buttonTwo.frame.size), for: .normal)
            buttonTwo.titleLabel?.text = nil
        }
        
    }
    
    
}

