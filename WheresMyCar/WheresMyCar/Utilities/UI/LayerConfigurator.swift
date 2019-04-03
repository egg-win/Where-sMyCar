//
//  LayerConfigurator.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/3.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

struct LayerShadowStyle {
    var cornerRadius: CGFloat?
    var shadowOpacity: Float?
    var shadowOffset: CGSize?
    var shadowRadius: CGFloat?
}

class LayerConfigurator {
    // MARK: - Properties
    private(set) var shadowStyle = LayerShadowStyle()
    
    // MARK: - Initializer
    init() {  }
    
    // MARK: - Public method
    func setup(shadowStyle: LayerShadowStyle) {
        self.shadowStyle = shadowStyle
    }
    
    func configure(layer: CALayer) {
        if let cornerRadius = shadowStyle.cornerRadius {
            layer.cornerRadius = cornerRadius
        }
        
        if let shadowOpacity = shadowStyle.shadowOpacity {
            layer.shadowOpacity = shadowOpacity
        }
        
        if let shadowOffset = shadowStyle.shadowOffset {
            layer.shadowOffset = shadowOffset
        }
        
        if let shadowRadius = shadowStyle.shadowRadius {
            layer.shadowRadius = shadowRadius
        }
    }
}
