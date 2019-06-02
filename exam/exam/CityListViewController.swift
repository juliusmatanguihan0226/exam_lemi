//
//  CityListViewController.swift
//  exam
//
//  Created by Julius Matanguihan on 01/06/2019.
//  Copyright © 2019 julius. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var tableViewCity: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    let cellReuseIdentifier = "cell"
    var cityArray = [[String: Any]]()
    var vSpinner : UIView?
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        self.navItem.titleView = searchBar
        self.tableViewCity.rowHeight = 65.0
        callAPI()
        self.tableViewCity.reloadData()
    }
    
    func callAPI() {
        showSpinner(onView: self.view)
        guard let url = URL(string: "https://lemi.travel/api/v5/cities") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                for dic in jsonArray{
                    self.cityArray.append(dic);
                    guard let title = dic["name"] as? String else { return }
                    print(title) //Output
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            DispatchQueue.main.async {
                self.tableViewCity.reloadData()
                self.removeSpinner()
            }
            
        }
        
        task.resume()
        
    }
    
    func searchAPi (searchString:String) {
        showSpinner(onView: self.view)
        guard let url = URL(string: "https://lemi.travel/api/v5/cities?q=" + searchString) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                self.cityArray.removeAll()
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                for dic in jsonArray{
                    self.cityArray.append(dic);
                    guard let title = dic["name"] as? String else { return }
                    print(title) //Output
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            DispatchQueue.main.async {
                self.tableViewCity.reloadData()
                self.removeSpinner()
            }
            
        }
        
        task.resume()
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityArray.count;
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:CityListTableViewCell = self.tableViewCity.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CityListTableViewCell
        // set the text from the data model
        cell.setupCell(cityArray: self.cityArray[indexPath.row])
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strName = self.cityArray[indexPath.row]["name"] as? String
        UserDefaults.standard.set(strName, forKey: "nameCity")
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchAPi(searchString:searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
