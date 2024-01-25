//
//  CategoryDetailVc.swift
//  RealmTestProj
//
//  Created by Максим Жуин on 24.01.2024.
//

import UIKit


final class CategoryDetailVc: UIViewController {

    var quotesValueArray: [QuotesValue]?

    private lazy var quotesTableView: UITableView = {
        let quotesTableView = UITableView()
        quotesTableView.translatesAutoresizingMaskIntoConstraints = false
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
        return quotesTableView
    }()

    init(quotesValueArray: [QuotesValue]? = nil) {
        self.quotesValueArray = quotesValueArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
    }


    private func layout() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(quotesTableView)

        NSLayoutConstraint.activate([
            quotesTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            quotesTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            quotesTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 10),
            quotesTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 10)
        ])
    }

}

extension CategoryDetailVc: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let quotesValueArray {
            return quotesValueArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        if let quotesExists = quotesValueArray {
            let quoteText = quotesExists[indexPath.row].value
            content.text = quoteText
            cell.contentConfiguration = content
        }
        return cell
    }
    

}

extension CategoryDetailVc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
