//
//  QuoteVC.swift
//  RealmTestProj
//
//  Created by Максим Жуин on 15.01.2024.
//

import UIKit
import RealmSwift


final class CategoryVC: UIViewController {

    private var categoryArray: [RealmServiceModel]

    private lazy var quotesTableView: UITableView = {
        let quotesTableView = UITableView()
        quotesTableView.translatesAutoresizingMaskIntoConstraints = false
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
        return quotesTableView
    }()

    init(quotesArray: [RealmServiceModel]) {
        self.categoryArray = quotesArray
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quotesTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        initialFetch()
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(quotesTableView)

        NSLayoutConstraint.activate([
            quotesTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            quotesTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            quotesTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            quotesTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    private func initialFetch() {
        do {
            let realm = try Realm()
            categoryArray = realm.objects(RealmServiceModel.self).map({ $0 })
        } catch {
            print("ERRR")
        }
    }
}


extension CategoryVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !categoryArray.isEmpty {
        return  categoryArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        let sectionKey = categoryArray[indexPath.row].key
        content.text = sectionKey
        cell.contentConfiguration = content
        return cell
    }

}

extension CategoryVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realmService = RealmService()
        let newArray = realmService.getArray(at: indexPath.row)
        let vc = ControllerBuilder.shared.createDetailCategoryVC(quotesArray: newArray)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
