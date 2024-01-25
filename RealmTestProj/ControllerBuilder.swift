//
//  ControllerBuilder.swift
//  RealmTestProj
//
//  Created by Максим Жуин on 24.01.2024.
//

import UIKit

final class ControllerBuilder {

    private let realmService = RealmService()

    static let shared = ControllerBuilder()

    private init() {
    }

    func createAllQuotesVC() -> UINavigationController {
        let networkService = NetworkService()
        let controller = ViewController(networkService: networkService, realmService: realmService)
        let leftTabBar = UITabBarItem(title: "Unsorted", image: UIImage(systemName: "doc"), tag: 0)
        controller.tabBarItem = leftTabBar
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }

    func createDetailCategoryVC(quotesArray: [QuotesValue]) -> CategoryDetailVc {
      let categoryDetailVc = CategoryDetailVc(quotesValueArray: quotesArray)
      return categoryDetailVc
    }

    func createCategoryVC() -> UINavigationController {
        let categoryVC = CategoryVC(quotesArray: realmService.realmModelArray)
        let rightTabBar = UITabBarItem(title: "Categories", image: UIImage(systemName: "doc.on.doc"), tag: 1)
        let categoryVCNavigation = UINavigationController(rootViewController: categoryVC)
        categoryVC.tabBarItem = rightTabBar
        return categoryVCNavigation
    }

}
