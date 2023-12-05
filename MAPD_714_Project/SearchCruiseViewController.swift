//
//  SearchCruiseViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-03.
//

import UIKit

// MARK: - Model

// Define the Cruise struct to hold cruise information
struct Cruise {
    let name: String
    let price: Double
    let startDate: Date
    let numberOfNights: Int
}

class SearchCruiseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    // Initialize an array to store the list of cruises
    var cruises: [Cruise] = [
        Cruise(name: "Bahamas Cruise", price: 500, startDate: Date(), numberOfNights: 7),
        Cruise(name: "Caribbean Cruise", price: 700, startDate: Date(), numberOfNights: 10),
        Cruise(name: "Cuba Cruise", price: 600, startDate: Date(), numberOfNights: 8),
        Cruise(name: "Sampler Cruise", price: 400, startDate: Date(), numberOfNights: 5),
        Cruise(name: "Star Cruise", price: 800, startDate: Date(), numberOfNights: 12)
    ]
    
    // Initialize an array to store filtered cruises
    var filteredCruises: [Cruise] = []
    
    // MARK: - Outlets

    // Connect table view and search bar from the storyboard
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign the delegate and data source for the table view and search bar
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Set the initial filtered cruises to all cruises
        filteredCruises = cruises
        
        // Register the cell identifier for the table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Customize the UI design
        customizeUI()
    }
    
    // MARK: - UI Customization

    // Set custom UI configurations for the table view and search bar
    func customizeUI() {
        // Customize table view
        tableView.separatorColor = .lightGray
        tableView.tableFooterView = UIView()
        
        // Customize search bar
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search Cruises"
        searchBar.tintColor = .systemBlue
    }
    
    // MARK: - Filtering Cruises

    // Function to filter cruises based on search text, price, start date, and number of nights
    func filterCruises(for searchText: String) {
        filteredCruises = cruises.filter { cruise in
            let searchTextMatches = cruise.name.lowercased().contains(searchText.lowercased())
            let priceMatches = "\(cruise.price)".contains(searchText)
            let startDateMatches = formatDate(date: cruise.startDate).contains(searchText)
            let numberOfNightsMatches = "\(cruise.numberOfNights)".contains(searchText)
            
            return searchTextMatches || priceMatches || startDateMatches || numberOfNightsMatches
        }
        
        tableView.reloadData() // Reload the table view data with the filtered results
    }

    // Helper method to format date
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

// MARK: - UISearchBarDelegate

extension SearchCruiseViewController: UISearchBarDelegate {
    // Perform actions when the text in the search bar changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCruises = cruises
        } else {
            filterCruises(for: searchText)
        }
        tableView.reloadData() // Reload the table view with the filtered results
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchCruiseViewController {
    // Define table view delegate and data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCruises.count // Return the number of filtered cruises
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) // Dequeue reusable cell for the table view
        let cruise = filteredCruises[indexPath.row] // Retrieve the corresponding cruise from the filtered list

        // Customize the cell to display the required information
        cell.textLabel?.text = "\(cruise.name)"
        cell.detailTextLabel?.text = "Price: $\(cruise.price) | Start Date: \(formatDate(date: cruise.startDate)) | Number of Nights: \(cruise.numberOfNights)"
        
        // Customize cell design
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.numberOfLines = 0

        return cell // Return the customized cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Adjust this value as per your requirement
    }
    
    // Perform actions when a row is selected in the table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCruise = filteredCruises[indexPath.row] // Get the selected cruise from the filtered list
        
        // Perform a segue based on the selected cruise's name
        switch selectedCruise.name {
        case "Bahamas Cruise":
            performSegue(withIdentifier: "ShowBahamas", sender: selectedCruise)
        case "Caribbean Cruise":
            performSegue(withIdentifier: "ShowCaribbean", sender: selectedCruise)
        case "Cuba Cruise":
            performSegue(withIdentifier: "ShowCuba", sender: selectedCruise)
        case "Sampler Cruise":
            performSegue(withIdentifier: "ShowSampler", sender: selectedCruise)
        case "Star Cruise":
            performSegue(withIdentifier: "ShowStar", sender: selectedCruise)
        default:
            break
        }
    }
    


}
