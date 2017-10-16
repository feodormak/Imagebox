//
//  ImageboxTransition.swift
//  Imagebox
//
//  Created by feodor on 16/10/17.
//  Copyright © 2017 feodor. All rights reserved.
//
// Originally based on hyperslo's Lightbox(https://github.com/hyperoslo/Lightbox), reduced for single images.

import UIKit

class ImageboxTransition: UIPercentDrivenInteractiveTransition {
    
    private var isDismissing = false
    private var initialOrigin: CGPoint = .zero
    
    var imageboxController: ImageboxController?
    var scrollView: UIScrollView? {
        didSet {
            guard let scrollView = scrollView else { return }
            scrollView.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    lazy private var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        gesture.delegate = self
        
        return gesture
    }()
    
    func transition(_ show: Bool) {
        if imageboxController != nil {
            imageboxController!.view.backgroundColor = UIColor.black.withAlphaComponent(show ? 1 : 0 )
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        if scrollView != nil && imageboxController != nil {
            
            let translation = gesture.translation(in: scrollView)
            let percentage = abs(translation.y) / UIScreen.main.bounds.height / 1.5
            let velocity = gesture.velocity(in: scrollView)
            
            switch gesture.state {
            case .began:
                initialOrigin = scrollView!.frame.origin
            case .changed:
                update(percentage)
                scrollView!.frame.origin.y = initialOrigin.y + translation.y
            case .ended, .cancelled:
                var time = translation.y * 3 / abs(velocity.y)
                if time > 1 { time = 0.7 }
                
                
                if percentage > ImageboxConstants.PanGesturePercentageLimit {
                    finish()
                    
                    UIView.animate(withDuration: TimeInterval(time), delay: 0, options: [.allowUserInteraction], animations: {
                        self.scrollView!.frame.origin.y = translation.y * 3
                        self.imageboxController!.view.alpha = 0
                        self.imageboxController!.dismiss(animated: true, completion: nil)
                    }, completion: {_ in })
                }
                    
                else {
                    cancel()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.035) {
                        UIView.animate(withDuration: 0.35, animations: {
                            self.scrollView!.frame.origin = self.initialOrigin
                        })
                    }
                }
            default: break
            }
        }
    }
    
}

extension ImageboxTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { return 0.25 }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            else { return }
        
        let firstView = isDismissing ? toView : fromView
        let secondView = isDismissing ? fromView : toView
        
        if !isDismissing { transition(false) }
        
        container.addSubview(firstView)
        container.addSubview(secondView)
        
        toView.frame = container.bounds
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            self.transition(!self.isDismissing)
        }, completion: { _ in
            transitionContext.transitionWasCancelled
                ? transitionContext.completeTransition(false)
                : transitionContext.completeTransition(true)
        })
    }
}

extension ImageboxTransition: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isDismissing = true
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) ->UIViewControllerAnimatedTransitioning? {
        isDismissing = false
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
}

extension ImageboxTransition: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        var result = false
        
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: gestureRecognizer.view)
            if fabs(translation.x) < fabs(translation.y) {
                result = true
            }
        }
        return result
    }
}

