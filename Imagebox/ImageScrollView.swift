//
//  ImageScrollView.swift
//  Imagebox
//
//  Created by feodor on 16/10/17.
//  Copyright © 2017 feodor. All rights reserved.
//
// Originally based on hyperslo's Lightbox(https://github.com/hyperoslo/Lightbox), reduced for single images. Includes code by,
// - Maintaining contentOffset: Kyle Redfearn @ https://innovation.vivint.com/maintaining-content-offset-when-the-size-of-your-uiscrollview-changes-554d7742885a
// - Zoom to max:  flashfail @ https://gist.github.com/TimOliver/71be0a8048af4bd86ede

import UIKit

class ImageScrollView: UIScrollView {
    
    private var image = UIImage()
    private var imageView = UIImageView()
    
    var contentOffsetRatio = CGPoint(x: 0.5, y: 0.5)
    
    override var contentOffset: CGPoint {
        didSet {
            let width = self.contentSize.width
            let height = self.contentSize.height
            let halfWidth = self.frame.size.width / 2.0
            let halfHeight = self.frame.size.height / 2.0
            let centerX = (self.contentOffset.x + halfWidth) / width
            let centerY = (self.contentOffset.y + halfHeight) / height
            self.contentOffsetRatio = CGPoint(x: centerX, y: centerY)
        }
    }
    
    init(image: UIImage) {
        super.init(frame: CGRect.zero)
        self.image = image
        
        backgroundColor = UIColor.clear
        contentSize = imageView.bounds.size
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        minimumZoomScale = min(widthScale, heightScale)
        maximumZoomScale = minimumZoomScale * 3.0
        zoomScale = minimumZoomScale
    }
    
    private func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
    }
    
    @objc private func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        
        if (zoomScale > minimumZoomScale) {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            let touchPoint = recognizer.location(in: self)
            if imageView.frame.contains(touchPoint) {
                zoomMax(toPoint: touchPoint, inFrame: imageView.frame, scale: ImageboxConstants.ScrollViewMaxZoomScale, animated: true)
            }
        }
    }
    
    func configureLayout(_ rect:CGRect) {
        frame = rect
        imageView = UIImageView(image: image)
        addSubview(imageView)
        
        setZoomScale()
        setupGestureRecognizer()
    }
    
    func screenRotated(size: CGSize, ratio: CGPoint) {
        
        let oldRelativeZoomScale = zoomScale - minimumZoomScale
        
        frame.size = size
        setZoomScale()
        
        if oldRelativeZoomScale != 0 {
            zoomScale += oldRelativeZoomScale
            determineNewContentOffset(ratio)
        }
        
    }
    
    private func determineNewContentOffset(_ ratio: CGPoint) {
        var frame = self.imageView.frame
        if frame != .zero {
            
            // Adjust the frame to be zero based since it can have a negative origin
            if frame.origin.x < 0 {
                frame = frame.offsetBy(dx: -frame.origin.x, dy: 0)
            }
            if frame.origin.y < 0 {
                frame = frame.offsetBy(dx: 0, dy: -frame.origin.y)
            }
            
            // Calculate the new content offset based off the contentOffsetRatio
            var offsetX = (ratio.x * self.contentSize.width) - (self.frame.size.width / 2.0)
            var offsetY = (ratio.y * self.contentSize.height) - (self.frame.size.height / 2.0)
            
            // Create a field of view rect witch represents where the scroll view will positioned with this new content offset
            var fov = CGRect(x:offsetX, y:offsetY, width:self.frame.size.width, height:self.frame.size.height)
            if fov.origin.x < 0 {
                fov = fov.offsetBy(dx: -fov.origin.x, dy: 0)
            }
            if fov.origin.y < 0 {
                fov = fov.offsetBy(dx: 0, dy: -fov.origin.y)
            }
            
            // If the new content offset is going to go outside the bounds of the new frame, reset
            // the x or y coordinate to its maximum value
            let intersection = fov.intersection(frame)
            if !intersection.size.equalTo(fov.size) {
                if (fov.maxX > frame.size.width) {
                    offsetX = frame.size.width -  fov.size.width
                }
                if (fov.maxY > frame.size.height) {
                    offsetY = frame.size.height -  fov.size.height
                }
            }
            
            // Preventing negative content offsets
            offsetY = offsetY > 0.0 ? offsetY : 0.0
            offsetX = offsetX > 0.0 ? offsetX : 0.0
            self.contentOffset = CGPoint(x:offsetX, y:offsetY)
        }
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
    }
}

extension UIScrollView {
    func zoomMax(toPoint zoomPoint : CGPoint, inFrame : CGRect, scale: CGFloat, animated : Bool) {
        
        let zoomFactor = 1.0 / zoomScale
        var translatedZoomPoint : CGPoint = .zero
        var destinationRect : CGRect = .zero
        
        translatedZoomPoint.x = zoomPoint.x * zoomFactor
        translatedZoomPoint.y = zoomPoint.y * zoomFactor
        
        destinationRect.size.width = frame.width / scale
        destinationRect.size.height = frame.height / scale
        
        destinationRect.origin.x = translatedZoomPoint.x - (destinationRect.width * 0.5)
        destinationRect.origin.y = translatedZoomPoint.y - (destinationRect.height * 0.5)
        if animated {
            UIView.animate(withDuration: 0.55, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: [.allowUserInteraction], animations: {
                self.zoom(to: destinationRect, animated: false)
            }, completion: {
                completed in
                if let delegate = self.delegate, delegate.responds(to: #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:))), let view = delegate.viewForZooming?(in: self) {
                    delegate.scrollViewDidEndZooming!(self, with: view, atScale: scale)
                }
            })
        } else {
            zoom(to: destinationRect, animated: false)
        }
    }
}



