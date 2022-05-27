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

        tableView?.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SchoolDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellIdentifier, for: indexPath) as UITableViewCell
        var content = cell.defaultContentConfiguration()
        let satScore = viewModel.cellForRow(at: indexPath.row)
        content.text = satScore?.description
        content.secondaryText = satScore?.getValue(details: viewModel.getSchoolDetails())
//        switch indexPath.row {
//        case 0:
//            content.text = viewModel.schoolName()
//        case 1:
//            let pair = viewModel.numberOfTestTakers()
//            content.text = pair.name
//            content.secondaryText = pair.value
//        case 2:
//            let pair = viewModel.criticalReadingScore()
//            content.text = pair.name
//            content.secondaryText = pair.value
//        case 3:
//            let pair = viewModel.mathScore()
//            content.text = pair.name
//            content.secondaryText = pair.value
//        case 4:
//            let pair = viewModel.writingScore()
//            content.text = pair.name
//            content.secondaryText = pair.value
//        default:
//            break
//        }
        cell.contentConfiguration = content
        return cell
    }
}
