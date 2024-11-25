//
//  FilterPredicateBuilder.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.11.2024.
//

import Foundation

import Foundation

final class FilterPredicateBuilder {
    private var predicates: [NSPredicate]
    private var currentLogicalType: NSCompoundPredicate.LogicalType
    
    init(type: PredicateType) {
        let initialPredicate = FilterPredicateFactory.makePredicate(for: type)
        self.predicates = [initialPredicate]
        self.currentLogicalType = .and
    }
    
    func and(_ type: PredicateType) -> FilterPredicateBuilder {
        let predicate = FilterPredicateFactory.makePredicate(for: type)
        addPredicate(predicate, logicalType: .and)
        return self
    }
    
    func or(_ type: PredicateType) -> FilterPredicateBuilder {
        let predicate = FilterPredicateFactory.makePredicate(for: type)
        addPredicate(predicate, logicalType: .or)
        return self
    }
    
    func and(_ predicate: NSPredicate) -> FilterPredicateBuilder {
        addPredicate(predicate, logicalType: .and)
        return self
    }
    
    func or(_ predicate: NSPredicate) -> FilterPredicateBuilder {
        addPredicate(predicate, logicalType: .or)
        return self
    }
    
    func build() -> NSPredicate {
        guard !predicates.isEmpty else {
            return NSPredicate(value: true)
        }
        return NSCompoundPredicate(type: currentLogicalType, subpredicates: predicates)
    }
    
    // MARK: - Private Methods
    private func addPredicate(_ predicate: NSPredicate, logicalType: NSCompoundPredicate.LogicalType) {
        if currentLogicalType != logicalType && !predicates.isEmpty {
            let compoundPredicate = NSCompoundPredicate(type: currentLogicalType, subpredicates: predicates)
            predicates = [compoundPredicate]
        }
        currentLogicalType = logicalType
        predicates.append(predicate)
    }
}
