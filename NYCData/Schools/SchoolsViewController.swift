//
//  SchoolsViewController.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation
import UIKit

/// If given more time, I want to add `search box` on top of the table view for easy search of the
/// school name as the number of shools are too many.
/// Also, pull to refresh is nice to have for this app to get latest data
class SchoolsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?

    /// I want to declare all the strings in a localized file to support multiple languages
    private let CellIdentifier = "SchoolsCell"
    private let SchoolsTitle = "NYC High Schools"
    private let DetailsSegue = "SchoolDetails"

    private var viewModel: SchoolsViewModel?

    // MARK: - View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Set title
        navigationItem.title = SchoolsTitle

        /// Set table viewe delegate and data source
        tableView?.delegate = self
        tableView?.dataSource = self

        /// Initialize view model
        viewModel = SchoolsViewModel(delegate: self)

        /// Show loading spinner
        showLoading(true)

        /// Make network call
        viewModel?.getSchools()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destination = segue.destination as? SchoolDetailsViewController,
            let data = sender as? SchoolDetailsViewModel {
            destination.setViewModel(data)
        }
    }

    // MARK: - Helper Methods
    fileprivate func showLoading(_ loading: Bool) {
        loading ? loadingIndicator?.startAnimating() : loadingIndicator?.stopAnimating()
    }

    fileprivate func retry() {
        showLoading(true)
        viewModel?.getSchools()
    }

    fileprivate func showGenericError() {
        /// TODO: Have a custom wrapper around UIAlertController to take care of all alerts

        /// Show Alert that there is some network issue
        /// Given more time, Declare the strings in a seperate constant file
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

// MARK: - UITableViewDelegate & UITableViewDataSource
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }

        if viewModel.areSchoolsDetailsLoaded() {
            let detailsViewModel = SchoolDetailsViewModel(scoolDetails: viewModel.selectedSchoolDetails())
            performSegue(withIdentifier: DetailsSegue, sender: detailsViewModel)
        } else {
            showLoading(true)
            /// Instead of making this network call always when the user clicks
            /// on school name. As network response is returning all the school's SAT score.
            /// I have decided make one time call and save the response to use it further
            /// This approach may not work if the data changes or if we need to get latest data
            viewModel.getSchoolsDetails()
        }
    }
}

// MARK: - SchoolsViewModelDelegate
extension SchoolsViewController: SchoolsViewModelDelegate {
    func getSchoolsCallSuccess() {
        showLoading(false)
        tableView?.reloadData()
    }
    
    func getSchoolsCallFailure(_ error: String) {
        showLoading(false)
        showGenericError()
    }

    func getSchoolsDetailsCallSuccess() {
        showLoading(false)
        guard let viewModel = viewModel else { return }
        let detailsViewModel = SchoolDetailsViewModel(scoolDetails: viewModel.selectedSchoolDetails())
        performSegue(withIdentifier: DetailsSegue, sender: detailsViewModel)
    }

    func getSchoolsDetailsCallFailure(_ error: String) {
        showLoading(false)
        showGenericError()
    }
}
