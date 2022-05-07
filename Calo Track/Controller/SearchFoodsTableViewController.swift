//
//  SearchFoodsTableViewController.swift
//  Calo Track
//
//  Created by Sushen Satturu on 4/5/2022.
//

import UIKit


class SearchFoodsTableViewController: UITableViewController, UISearchBarDelegate {
    
    let CELL_FOOD = "foodCell"
    let REQUEST_STRING = "https://trackapi.nutritionix.com/v2/search/instant?query="
    
    var newFoods = [FoodData]()
    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        print("VIEW LOADED")
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Foods"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController

        // Ensure the search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newFoods.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_FOOD, for: indexPath)
        let food = newFoods[indexPath.row]

        cell.textLabel?.text = food.foodName!
        print("BRAND NAME")
        print(food.brandName)
        cell.detailTextLabel?.text = food.brandName!

        return cell
    }
    
    // MARK: - API Methods
    
    func requestFoodsNamed(_ foodName: String) async {
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "trackapi.nutritionix.com"
        searchURLComponents.path = "/v2/search/instant"
        
        searchURLComponents.queryItems = [
            URLQueryItem(name: "query", value: foodName)
        ]
        
        guard let requestUrl = searchURLComponents.url else {
            print("Invalid URL")
            return
        }
        
        // make a struct ApiKey and define API KEYS
        let headers = ["x-app-id":ApiKeys.X_APP_ID, "x-app-key":ApiKeys.X_APPLICATION_KEY, "x-remote-user-id":"0"]
        var urlRequest = URLRequest(url: requestUrl)
        
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }

            
            let decoder = JSONDecoder()
            let volumeData = try decoder.decode(VolumeData.self, from: data)
            
            if let foods = volumeData.foods {
                newFoods.append(contentsOf: foods)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }

        } catch let error {
            print(error)
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.lowercased() else { return }
        
        newFoods.removeAll()
        tableView.reloadData()
        
        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()
        
        Task {
            await requestFoodsNamed(searchText)
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
