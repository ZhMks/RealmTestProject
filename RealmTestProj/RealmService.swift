//
//  RealmService.swift
//  RealmTestProj
//
//  Created by Максим Жуин on 20.01.2024.
//

import Foundation
import RealmSwift


final class RealmService {

    private(set) var realmModelArray = [RealmServiceModel]()
    private let scheme = Realm.Configuration(schemaVersion: 1)
    init() {
        Realm.Configuration.defaultConfiguration = scheme
        fetchData()
    }

    func fetchData() {
        do {
            let realm = try Realm()
            realmModelArray = realm.objects(RealmServiceModel.self).map({ $0 })
        } catch {
            print(error.localizedDescription)
            realmModelArray = []
        }
    }

    func saveInRealm(object: NetworkModel) {

        let date: Date = .now

        let quoteValue = QuotesValue()


        guard let realm = try? Realm() else { return }

        do {
            try realm.write {
                if object.categories.first != nil {
                    if realmModelArray.contains(where: { $0.key == object.categories.first }) {
                        quoteValue.value.append(object.value)
                        quoteValue.dateCreated = date
                        realmModelArray.first?.quotesArray.append(quoteValue)
                        fetchData()
                    } else {
                        let newRealmModel = RealmServiceModel()
                        quoteValue.value.append(object.value)
                        quoteValue.dateCreated = date
                        newRealmModel.key = object.categories.first!
                        newRealmModel.quotesArray.append(quoteValue)
                        realm.add(newRealmModel)
                        fetchData()
                    }
                } else if realmModelArray.contains(where: { $0.key == "Other" }) {
                    quoteValue.value.append(object.value)
                    quoteValue.dateCreated = date
                    realmModelArray.first?.quotesArray.append(quoteValue)
                    realmModelArray.first?.quotesArray.first?.dateCreated = date
                    fetchData()
                } else if !realmModelArray.contains(where: { $0.key == "Other" }) && object.categories.first == nil {
                    let newRealmModel = RealmServiceModel()
                    newRealmModel.key = "Other"
                    quoteValue.value = object.value
                    quoteValue.dateCreated = date
                    newRealmModel.quotesArray.append(quoteValue)
                    realm.add(newRealmModel)
                    fetchData()
                } else {
                    let newRealmModel = RealmServiceModel()
                    newRealmModel.key = object.categories.first!
                    quoteValue.value = object.value
                    quoteValue.dateCreated = date
                    newRealmModel.quotesArray.append(quoteValue)
                    realm.add(newRealmModel)
                    fetchData()
                }
            }
        } catch {
            print("ERORRRRRRRRR")
        }
    }

    func getArray(at index: Int) -> [QuotesValue] {

        let newArray = realmModelArray.map { models in
            Array(models.quotesArray)
        }
        let arrayAtIndex = newArray[index]

        return arrayAtIndex
    }
}
