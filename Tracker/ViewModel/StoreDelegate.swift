//
//  Binding.swift
//  Tracker
//
//  Created by Alexander Bralnin on 08.11.2024.
//

typealias Binding<T> = (T) -> Void

protocol StoreDelegate: AnyObject {
    func storeDidUpdate()
}
