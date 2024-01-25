//
//  RealmServiceModel.swift
//  RealmTestProj
//
//  Created by Максим Жуин on 18.01.2024.
//

import Foundation
import RealmSwift


final class RealmServiceModel: Object {
    @Persisted var key: String
    @Persisted var quotesArray: List<QuotesValue>
}

class QuotesValue: Object {
    @Persisted var value: String
    @Persisted var dateCreated: Date
}
