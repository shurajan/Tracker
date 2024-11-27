//
//  Colors.swift
//  Tracker
//
//  Created by Alexander Bralnin on 22.11.2024.
//

import UIKit

enum AppColors {
    
    enum Dynamic {
        static let black = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "#FFFFFF") // Белый в темной теме
            : UIColor(hex: "#1A1B22") // Черный в светлой теме
        }
        
        static let white = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "#1A1B22") // Черный в темной теме
            : UIColor(hex: "#FFFFFF") // Белый в светлой теме
        }
        
        static let background = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "#414141D9") // Dark background with 85% opacity
            : UIColor(hex: "#E6E8EB4D") // Light background with 30% opacity
        }
    }
    
    enum Fixed {
        static let black = UIColor(hex: "#1A1B22")
        static let white = UIColor(hex: "#FFFFFF")
        static let gray = UIColor(hex: "#AEAFB4")
        static let lightGray = UIColor(hex: "#E6E8EB")
        static let red = UIColor(hex: "#F56B6C")
        static let blue = UIColor(hex: "#3772E7")
        static let cardBackground = UIColor(hex: "#F0F0F0")
    }
}
