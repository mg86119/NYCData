//
//  SchoolsViewController.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation
import UIKit

/// If given more time,
/// want to add pull to refresh and sorting
class SchoolsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    @IBOutlet weak var searchBar: UISearchBar?

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

        /// Set table view delegate and data source
        tableView?.delegate = self
        tableView?.dataSource = self

        /// Set search bar delegate
        searchBar?.delegate = self
        searchBar?.showsCancelButton = false

        /// Initialize view model
        viewModel = SchoolsViewModel(delegate: self)

        /// Show loading spinner
        showLoading(true)

        /// Make network call
        viewModel?.getSchools()
    }

    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
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

    fileprivate func retry(dbn: String = "") {
        guard let viewModel = viewModel else { return }

        showLoading(true)
        switch viewModel.lastNetworkCall {
        case .schools:
            viewModel.getSchools()
        case .schoolDetails:
            viewModel.getSchoolsDetails(dbn: dbn)
        }
    }

    fileprivate func showGenericError(title: String = "OOPS",
                                      subTitle: String = "Something went wrong. Please try again.",
                                      noRetry: Bool = false,
                                      dbn: String = "") {
        /// TODO: Have a custom wrapper around UIAlertController to take care of all alerts
        /// Need ot declare all strings as constants

        /// Show Alert that there is some network issue
        /// Given more time, Declare the strings in a seperate constant file
        let alert = UIAlertController(title: title,
                                      message: subTitle,
                                      preferredStyle: .alert)
        if !noRetry {
            let okAction = UIAlertAction(title: "Retry", style: .default,
                                         handler: {
                [weak self] action in
                self?.retry(dbn: dbn)
            })
            alert.addAction(okAction)
        }

        let cancelAction = UIAlertAction(title: "Okay",
                                         style: .cancel,
                                         handler: nil)
        alert.addAction(cancelAction)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SchoolsViewController: UITableViewDelegate,
                                    UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfSchools() ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier,
                                                 for: indexPath) as UITableViewCell
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.schoolName(for: indexPath.row)
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }

        /// Get the `dbn` value of the selected school and pass to Details view model to  get the SAT scores
        let dbn = viewModel.selectedDBN(for: indexPath.row)

        if viewModel.areSchoolsDetailsLoaded() {
            /// Check if the `dbn` is present in SAT score array i.e. `schoolsDetails`
            /// I don't know why some of the `dbn`s are not present in the other array.
            /// For now, I am going to show an alert but need to handle in a better way as per requirement
            if let details = viewModel.selectedSchoolDetails(dbn: dbn) {
                let detailsViewModel = SchoolDetailsViewModel(scoolDetails: details)
                performSegue(withIdentifier: DetailsSegue, sender: detailsViewModel)
            } else {
                showGenericError(title: "Details not found",
                                 subTitle: "This school doesn't contain details at this time. Please try again later",
                                 noRetry: true)
            }

        } else {
            showLoading(true)
            /// Instead of making this network call always when the user clicks
            /// on school name. As network response is returning all the school's SAT score.
            /// I have decided make one time call and save the response to use it further
            /// This approach may not work if the data changes or if we need to get latest data
            viewModel.getSchoolsDetails(dbn: dbn)
        }
    }
}

// MARK: - SchoolsViewModelDelegate
extension SchoolsViewController: SchoolsViewModelDelegate {
    func getSchoolsCallSuccess() {
        guard let viewModel = viewModel else { return }
        showLoading(false)
        viewModel.setFilteredSchools(schools: viewModel.getAllSchools())
        tableView?.reloadData()
    }
    
    func getSchoolsCallFailure(_ error: String) {
        showLoading(false)
        showGenericError()
    }

    func getSchoolsDetailsCallSuccess(dbn: String) {
        showLoading(false)
        guard let viewModel = viewModel,
            let details = viewModel.selectedSchoolDetails(dbn: dbn) else { return }

        let detailsViewModel = SchoolDetailsViewModel(scoolDetails: details)
        performSegue(withIdentifier: DetailsSegue,
                     sender: detailsViewModel)
    }

    func getSchoolsDetailsCallFailure(_ error: String, dbn: String) {
        showLoading(false)
        showGenericError(dbn: dbn)
    }
}

extension SchoolsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let viewModel = viewModel else { return }

        // Reset filtered schools first
        viewModel.setFilteredSchools(schools: [:])

        if searchText.count > 0 {
            searchBar.showsCancelButton = true
            let allSchools = viewModel.getAllSchools()
            for school in allSchools {
                if school.value.lowercased().contains(searchText.lowercased()) {
                    viewModel.appendFilteredSchool(school: (school.key, school.value))
                }
            }
        } else {
            searchBar.showsCancelButton = false
            viewModel.setFilteredSchools(schools: viewModel.getAllSchools())
        }
        tableView?.reloadData()
    }
}
