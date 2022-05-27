//
//  SchoolDetailsViewController.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation
import UIKit

/// School Details View Controller
class SchoolDetailsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?

    private var viewModel: SchoolDetailsViewModel?

    /// I want to declare all the strings in a localized file to support multiple languages
    private let DetailsCellIdentifier = "SchoolDetailsCell"
    private let SchoolDetails = "School Details"

    /// Set viewModel
    func setViewModel(_ viewModel: SchoolDetailsViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Set title
        navigationItem.title = SchoolDetails

        /// Set table viewe delegate and data source
        tableView?.delegate = self
        tableView?.dataSource = self

        /// Reload data
        tableView?.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SchoolDetailsViewController: UITableViewDelegate,
                                        UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier,
                                                 for: indexPath) as UITableViewCell
        var content = cell.defaultContentConfiguration()
        let satScore = viewModel.cellForRow(at: indexPath.row)
        content.text = satScore?.getValue(details: viewModel.getSchoolDetails())
        content.secondaryTextProperties.font = .boldSystemFont(ofSize: 14)
        content.secondaryTextProperties.color = .systemGray
        content.secondaryText = satScore?.description
        cell.contentConfiguration = content
        return cell
    }
}
