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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?

    private let CellIdentifier = "SchoolsCell"
    private let SchoolsTitle = "Schools"

    private var viewModel: SchoolsViewModel?

    override func viewDidLoad() {
        // Set title
        navigationItem.title = SchoolsTitle

        // Set table viewe delegate and data source
        tableView?.delegate = self
        tableView?.dataSource = self

        // Initialize view model
        viewModel = SchoolsViewModel(delegate: self)

        // Show loading spinner
        showLoading(true)

        // Make network call
        viewModel?.getSchools()
    }

    fileprivate func showLoading(_ loading: Bool) {
        loading ? loadingIndicator?.startAnimating() : loadingIndicator?.stopAnimating()
    }

    fileprivate func retry() {
        showLoading(true)
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

extension SchoolsViewController: SchoolsViewModelDelegate {
    func isSucess() {
        showLoading(false)
        tableView?.reloadData()
    }
    
    func isError(_ error: String) {
        showLoading(false)

        // TODO: Have a custom wrapper around UIAlertController to take care of all alerts

        // Show Alert that there is some network issue
        let alert = UIAlertController(title: "OOPS", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Retry", style: .default, handler: {
            [weak self] action in
            self?.retry()
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
