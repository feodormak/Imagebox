//
//  ImageboxConstants.swift
//  Imagebox
//
//  Created by feodor on 16/10/17.
//  Copyright © 2017 feodor. All rights reserved.
//
// Originally based on hyperslo's Lightbox(https://github.com/hyperoslo/Lightbox), reduced for single images.

import UIKit

//The following can be changed to customise the behaviour/look
enum ImageboxConstants {
    static let ScrollViewMaxZoomScale: CGFloat = 3.0
    static let PanGesturePercentageLimit: CGFloat = 0.15
    static let CloseButtonText = NSLocalizedString("×", comment: "")
    static let CloseButtonTextAttributes = [
        NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16),
        NSAttributedStringKey.foregroundColor: UIColor.white,
        NSAttributedStringKey.paragraphStyle: {
            var style = NSMutableParagraphStyle()
            style.alignment = .center
            return style
        }()
    ]
    static let CloseButtonSpacingFromTop: CGFloat = 8
    static let CloseButtonSpacingFromRight: CGFloat = -2
}
