//
//  Receipt.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Receipt {
    
    var title: String?
    var info: String?
    var address: String?
    var phone: String?
    var email: String?
    var date: Date?
    
    @Relationship
    var type: ReceiptType?
//    var important: Bool?
    
    @Transient
    var fullInfo = [String]()
    
    init() {}
    
    init(title: String, info: String, address: String, phone: String, email: String, date: Date) {
        self.title = title
        self.info = info
        self.address = address
        self.phone = phone
        self.email = email
        self.date = date
        self.fullInfo = []
    }
    
//    static func predicate(searchText: String, group: ReceiptType?) -> Predicate<Receipt> {
//        func buildConjunction(lhs: some StandardPredicateExpression<Bool>, rhs: some StandardPredicateExpression<Bool>) -> any StandardPredicateExpression<Bool> {
//            PredicateExpressions.Conjunction(lhs: lhs, rhs: rhs)
//        }
//        
//        //        return #Predicate<Receipt> { receipt in
//        //            if let title = receipt.title {
//        //                return searchText.isEmpty || title.localizedStandardContains(searchText)
//        //            } else {
//        //                return false
//        //            }
//        //        }
//        typealias ReceiptVariable = PredicateExpressions.Variable<Receipt>
//        typealias ReceiptKeyPath<T> = PredicateExpressions.KeyPath<ReceiptVariable, T>
//        
//            return Predicate<Receipt> ({ receipt in
//            
//                var conditions: [any StandardPredicateExpression<Bool>] = []
//                
//                let titleExpression = ReceiptKeyPath<String?>(keyPath: \.title)
//                let typeExpression = ReceiptKeyPath<ReceiptType?>(keyPath: \.type)
//
//                let containsTextPredicate =
//                        PredicateExpressions.build_Disjunction(
//                            lhs: PredicateExpressions.build_KeyPath(
//                                root: PredicateExpressions.build_Arg(searchText),
//                                keyPath: \.isEmpty
//                            ),
//                            rhs: PredicateExpressions.build_localizedStandardContains(
//                                PredicateExpressions.build_Arg(\.title),
//                                PredicateExpressions.build_Arg(searchText)
//                            )
//                        )
//                
//                let dateEquals = { (input: BookKeyPath<Date>, _ value: Date) in
//                    return PredicateExpressions.Equal(
//                        lhs: input,
//                        rhs: PredicateExpressions.Value(value)
//                    )
//                }
//                    
//                
//                let isGroupSelectedPredicate
//                
//                
//            })
//        }
//    }

static func predicate(searchText: String, group: ReceiptType?) -> Predicate<Receipt> {
            return #Predicate<Receipt> { receipt in
                if let title = receipt.title {
                    return searchText.isEmpty || title.localizedStandardContains(searchText)
                } else {
                    return false
                }
            }
}

}
