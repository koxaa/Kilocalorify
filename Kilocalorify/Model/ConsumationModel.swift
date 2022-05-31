//
//  ConsumationModel.swift
//  Kilocalorify
//
//  Created by user222636 on 5/31/22.
//

import Foundation
import CoreData

extension Consumation {
    
    static func addNewConsumation(amount: Float, timestamp: Date = Date(), product: Product, _MOC: NSManagedObjectContext) -> Consumation {
        let _consumation = Consumation(context: _MOC)
        
        _consumation.amount = amount
        _consumation.timestamp = timestamp
        _consumation.product = product
        
        return _consumation
    }
    
//    static func fetchConsumations(_MOC: NSManagedObjectContext) {
//        let _fr = Consumation.fetchRequest()
//        
//        if let _result = try? _MOC.fetch(_fr) {
//            return _result
//        } else {
//            return [Consumation]()
//        }
//    }
}
