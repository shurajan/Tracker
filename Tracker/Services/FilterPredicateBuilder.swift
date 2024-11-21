//
//  FilterPredicateBuilder.swift
//  Tracker
//
//  Created by Alexander Bralnin on 21.11.2024.
//

import Foundation

final class FilterPredicateBuilder {
    private var predicates: [NSPredicate]
    private var currentLogicalType: NSCompoundPredicate.LogicalType
    
    init(_ initialPredicate: NSPredicate = NSPredicate(value: true)) {
        self.predicates = [initialPredicate]
        self.currentLogicalType = .and
    }
    
    func and(_ filter: Filters, date: Date) -> FilterPredicateBuilder {
        let predicate = FilterPredicateFactory.makePredicate(for: filter, date: date)
        addPredicate(predicate, logicalType: .and)
        return self
    }
    
    func and(_ predicate: NSPredicate) -> FilterPredicateBuilder {
        addPredicate(predicate, logicalType: .and)
        return self
    }
    
    func or(_ filter: Filters, date: Date) -> FilterPredicateBuilder {
        let predicate = FilterPredicateFactory.makePredicate(for: filter, date: date)
        addPredicate(predicate, logicalType: .or)
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
