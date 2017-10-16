//
//  ImageboxController.swift
//  Imagebox
//
//  Created by feodor on 16/10/17.
//  Copyright © 2017 feodor. All rights reserved.
//
// Originally based on hyperslo's Lightbox(https://github.com/hyperoslo/Lightbox), reduced for single images.

import UIKit

class ImageboxController: UIViewController, UIScrollViewDelegate {
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let bounds = (UIApplication.shared.delegate?.window??.bounds)!
        scrollView.frame = bounds
        scrollView.contentSize = bounds.size
        scrollView.contentOffset = CGPoint.zero
        scrollView.isPagingEnabled = false
        scrollView.isUserInteractionEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        
        return scrollView
    }()
    private var imageScrollView:ImageScrollView?
    private var transitionManager: ImageboxTransition = ImageboxTransition()
    
    private var closeButton: UIButton = {
        let title = NSAttributedString(string: ImageboxConstants.CloseButtonText, attributes: ImageboxConstants.CloseButtonTextAttributes)
        let button = UIButton(type: .system)
        
        
        button.setAttributedTitle(title, for: UIControlState())
        button.sizeToFit()
        
        button.addTarget(self, action: #selector(closeButtonDidPress(_:)), for: .touchUpInside)
        button.isHidden = false
        button.backgroundColor = .clear
        
        return button
    }()
    
    init(image: UIImage) {
        imageScrollView = ImageScrollView(image: image)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageScrollView != nil {
            let buttonTopConstraint = NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: ImageboxConstants.CloseButtonSpacingFromTop)
            let buttonRightConstraint = NSLayoutConstraint(item: closeButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: ImageboxConstants.CloseButtonSpacingFromRight)
            
            imageScrollView!.configureLayout(view.bounds)
            
            view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            transitionManager.imageboxController = self
            transitionManager.scrollView = scrollView
            
            view.addSubview(scrollView)
            view.addSubview(closeButton)
            scrollView.addSubview(imageScrollView!)
            
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints([buttonTopConstraint, buttonRightConstraint])
        }
    }
    
    @objc private func closeButtonDidPress(_ button:UIButton){
        closeButton.isEnabled = false
        self.dismiss(animated: true, completion: nil)
    }
    
    //Handling screen rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let ratio:CGPoint = imageScrollView == nil ? .zero : self.imageScrollView!.contentOffsetRatio
        coordinator.animate(alongsideTransition: { (context) in
            self.scrollView.frame.size = size
            self.scrollView.contentSize = size
            if self.imageScrollView != nil {
                self.imageScrollView!.screenRotated(size: size, ratio: ratio)
            }
        }, completion: nil)
    }
}


