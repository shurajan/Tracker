//
//  TrackerColor.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.10.2024.
//
import UIKit

enum TrackerColor: String, CaseIterable {
    case selection1 = "#FD4C49"   
    case selection2 = "#FF881E"
    case selection3 = "#007BFA"
    case selection4 = "#6E44FE"
    case selection5 = "#33CF69"
    case selection6 = "#E66DD4"
    case selection7 = "#F9D4D4"
    case selection8 = "#34A7FE"
    case selection9 = "#46E69D"
    case selection10 = "#35347C"
    case selection11 = "#FF674D"
    case selection12 = "#FF99CC"
    case selection13 = "#F6C48B"
    case selection14 = "#7994F5"
    case selection15 = "#832CF1"
    case selection16 = "#AD56DA"
    case selection17 = "#8D72E6"
    case selection18 = "#2FD058"
    
    var uiColor: UIColor {
        return UIColor(hex: self.rawValue)
    }
}
