//
//  UIViewExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

extension UIView {
    func addGradientLayer(with size: CGRect, colors: [UIColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = size
        gradientLayer.colors = colors.map { $0.cgColor }
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
}

// MARK: - Autolayout method version 3
extension UIView {
    typealias Constraint = (_ subView: UIView, _ parentView: UIView) -> NSLayoutConstraint
    
    func addSubview(_ subview: UIView, constraints: [Constraint]) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(constraints.map { $0(subview, self) })
    }
    
    static func constraintEqual<LayoutAnchor, Axis>(from subViewKeyPath: KeyPath<UIView, LayoutAnchor>, to parentViewKeyPath: KeyPath<UIView, LayoutAnchor>, constant: CGFloat = 0.0) -> Constraint where LayoutAnchor: NSLayoutAnchor<Axis> {
        return { subView, parentView in
            subView[keyPath: subViewKeyPath].constraint(equalTo: parentView[keyPath: parentViewKeyPath], constant: constant)
        }
    }
    
    static func constraintEqual<LayoutAnchor, Axis>(to viewKeyPath: KeyPath<UIView, LayoutAnchor>, constant: CGFloat = 0.0) -> Constraint where LayoutAnchor: NSLayoutAnchor<Axis> {
        return constraintEqual(from: viewKeyPath, to: viewKeyPath, constant: constant)
    }
    
    static func constraintEqual<LayoutAnchor>(to viewKeyPath: KeyPath<UIView, LayoutAnchor>, constant: CGFloat) -> Constraint where LayoutAnchor: NSLayoutDimension {
        return { subview, _ in
            subview[keyPath: viewKeyPath].constraint(equalToConstant: constant)
        }
    }
}

// MARK: - Autolayout method version 2
extension UIView {
    enum Anchor {
        case topAnchor(constraint: NSLayoutYAxisAnchor, constant: CGFloat)
        case leadingAnchor(constraint: NSLayoutXAxisAnchor, constant: CGFloat)
        case bottomAnchor(constraint: NSLayoutYAxisAnchor, constant: CGFloat)
        case trailingAnchor(constraint: NSLayoutXAxisAnchor, constant: CGFloat)
        case widthAnchor(constant: CGFloat)
        case widthAnchorEqualTo(dimension: NSLayoutDimension, multiplier: CGFloat)
        case heightAnchor(constant: CGFloat)
        case horizontalAnchor(constraint: NSLayoutXAxisAnchor, constant: CGFloat)
        case verticalAnchor(constraint: NSLayoutYAxisAnchor, constant: CGFloat)
    }
    
    func anchor(_ anchors: [Anchor]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        anchors.forEach {
            switch $0 {
            case .topAnchor(let constraint, let constant):
                topAnchor.constraint(equalTo: constraint, constant: constant).isActive = true
            case .leadingAnchor(let constraint, let constant):
                leadingAnchor.constraint(equalTo: constraint, constant: constant).isActive = true
            case .bottomAnchor(let constraint, let constant):
                bottomAnchor.constraint(equalTo: constraint, constant: -constant).isActive = true
            case .trailingAnchor(let constraint, let constant):
                trailingAnchor.constraint(equalTo: constraint, constant: -constant).isActive = true
            case .widthAnchor(let constant):
                widthAnchor.constraint(equalToConstant: constant).isActive = true
            case .widthAnchorEqualTo(let dimension, let multiplier):
                widthAnchor.constraint(equalTo: dimension, multiplier: multiplier).isActive = true
            case .heightAnchor(let constant):
                heightAnchor.constraint(equalToConstant: constant).isActive = true
            case .horizontalAnchor(constraint: let constraint, constant: let constant):
                centerXAnchor.constraint(equalTo: constraint, constant: constant).isActive = true
            case .verticalAnchor(constraint: let constraint, constant: let constrant):
                centerYAnchor.constraint(equalTo: constraint, constant: constrant).isActive = true
            }
        }
    }
}

// MARK: - Autolayout method version 1
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                topConstant: CGFloat = 0,
                leadingConstant: CGFloat = 0,
                bottomConstant: CGFloat = 0,
                trailingConstant: CGFloat = 0,
                widthConstant: CGFloat = 0,
                heightConstant: CGFloat = 0) {
        _ = anchorWithReturnAnchors(top: top,
                                    leading: leading,
                                    bottom: bottom,
                                    trailing: trailing,
                                    topConstant: topConstant,
                                    leadingConstant: leadingConstant,
                                    bottomConstant: bottomConstant,
                                    trailingConstant: trailingConstant,
                                    widthConstant: widthConstant,
                                    heightConstant: heightConstant)
    }
    
    func anchorWithReturnAnchors(top: NSLayoutYAxisAnchor? = nil,
                                 leading: NSLayoutXAxisAnchor? = nil,
                                 bottom: NSLayoutYAxisAnchor? = nil,
                                 trailing: NSLayoutXAxisAnchor? = nil,
                                 topConstant: CGFloat = 0,
                                 leadingConstant: CGFloat = 0,
                                 bottomConstant: CGFloat = 0,
                                 trailingConstant: CGFloat = 0,
                                 widthConstant: CGFloat = 0,
                                 heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let leading = leading {
            anchors.append(leading.constraint(equalTo: leading, constant: leadingConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let trailing = trailing {
            anchors.append(trailingAnchor.constraint(equalTo: trailing, constant: trailingConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach { $0.isActive = true }
        return anchors
    }
}
