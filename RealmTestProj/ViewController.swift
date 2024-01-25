//
//  ViewController.swift
//  RealmTestProj
//
//  Created by Максим Жуин on 15.01.2024.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    private let networkService: NetworkService
    private let realmService: RealmService
    private var quotesDictArray: [RealmServiceModel]?


    private lazy var quoteTableView: UITableView = {
        let quoteTableView = UITableView()
        quoteTableView.translatesAutoresizingMaskIntoConstraints = false
        quoteTableView.delegate = self
        quoteTableView.dataSource = self
        return quoteTableView
    }()

    lazy var fetchQuoteButton: UIButton = {
        let fetchButton = UIButton(type: .system)
        fetchButton.translatesAutoresizingMaskIntoConstraints = false
        fetchButton.setTitle("Загрузить цитату", for: .normal)
        fetchButton.setTitleColor(.white, for: .normal)
        fetchButton.backgroundColor = .systemBlue
        fetchButton.layer.cornerRadius = 8.0
        fetchButton.addTarget(self, action: #selector(fetchQuoteButtonTapped(_:)), for: .touchUpInside)
        return fetchButton
    }()

    init(networkService: NetworkService, realmService: RealmService) {
        self.networkService = networkService
        self.realmService = realmService
        super.init(nibName: nil, bundle: nil)
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: .plain, target: self, action: #selector(sortData))
        navigationItem.rightBarButtonItem = rightButton
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        initialFetch()
    }


    private func layout() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(quoteTableView)
        view.addSubview(fetchQuoteButton)

        NSLayoutConstraint.activate([
            quoteTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            quoteTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            quoteTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            quoteTableView.bottomAnchor.constraint(equalTo: fetchQuoteButton.topAnchor, constant: -15),

            fetchQuoteButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -25),
            fetchQuoteButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }

    @objc func fetchQuoteButtonTapped(_ sender: UIButton) {
        guard let url = URL.init(string: "https://api.chucknorris.io/jokes/random") else { return }
        networkService.fetchQuote(with: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    realmService.saveInRealm(object: success)
                    initialFetch()
                    quoteTableView.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    private func initialFetch () {
        realmService.fetchData()
        quotesDictArray = realmService.realmModelArray.map({ $0 })
    }


    @objc func sortData() {
        realmService.fetchData()
        do {
            try Realm().write {
                quotesDictArray?.forEach { (model) in
                        model.quotesArray.sort { $0.dateCreated < $1.dateCreated }
                    }
                    quoteTableView.reloadData()
            }
        } catch {
            print("Array is empty")
        }
    }
    

}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let array = quotesDictArray else { return 0 }
        if array.isEmpty {
            return 0
        } else {
            return array.count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "QUOTES"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array = quotesDictArray else { return 0 }
        if array.isEmpty {
            return 0
        } else {
            return array[section].quotesArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        let text = quotesDictArray?[indexPath.section].quotesArray[indexPath.row].value
        content.text = text
        cell.contentConfiguration = content
        return cell
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

