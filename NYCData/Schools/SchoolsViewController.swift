//
//  SchoolsViewController.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation
import UIKit

class SchoolsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?

    private let CellIdentifier = "SchoolsCell"
    private let SchoolsTitle = "Schools"

    private var viewModel: SchoolsViewModel?

    override func viewDidLoad() {
        navigationItem.title = SchoolsTitle
        tableView?.delegate = self
        tableView?.dataSource = self
        viewModel = SchoolsViewModel()
        viewModel?.getSchools()
    }
}

extension SchoolsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfSchools() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as UITableViewCell
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.schoolName(for: indexPath.row)
        cell.contentConfiguration = content
        return cell
    }
}
