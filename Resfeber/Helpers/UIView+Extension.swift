//
//  UIView+Extension.swift
//  Resfeber
//
//  Created by David Wright on 11/8/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    func centerX(inView view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
    }

    func centerY(inView view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
    }

    func setDimensions(height: CGFloat? = nil, width: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}

extension UIView {
    
    enum BorderStyle { case none, top, bottom, topAndBottom }
    
    func addBorder(_ borderStyle: BorderStyle) {
        
        func horizontalLine() -> UIView {
            let line = UIView()
            line.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
            line.setDimensions(height: 1, width: frame.width)
            return line
        }
                
        switch borderStyle {
        case .top:
            let hLine = horizontalLine()
            addSubview(hLine)
            hLine.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        case .bottom:
            let hLine = horizontalLine()
            addSubview(hLine)
            hLine.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        case .topAndBottom:
            let hLineTop = horizontalLine()
            addSubview(hLineTop)
            hLineTop.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
            let hLineBottom = horizontalLine()
            addSubview(hLineBottom)
            hLineBottom.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        case .none:
            break
        }
    }
}
