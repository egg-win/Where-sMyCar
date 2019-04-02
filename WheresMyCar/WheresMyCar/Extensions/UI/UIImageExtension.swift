//
//  UIImageExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

extension UIImage {
    // MARK: - Properties
    private enum ImageName: String {
        case image
        // Add more image case
    }
    
    static var map: UIImage {
        return UIImage.image(of: .image)
    }
    
    // Add more image...
    
    // MARK: - Private method
    private static func image(of name: ImageName) -> UIImage {
        return UIImage(named: name.rawValue) ?? UIImage()
    }
}
