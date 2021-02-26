//
//  ViewController.swift
//  Weather
//
//  Created by Regisha on 18.02.2021.
//

//import UIKit
//
//class ViewController: UIViewController {
//
//    @IBOutlet weak var SearchBar: UISearchBar!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        SearchBar.delegate = self
//    }
//}
//extension ViewController:UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let urlString = "http://api.weatherstack.com/current?access_key=feb1985c4502cc4da000325373aebe19&query=\(SearchBar.text!)"
//        let url = URL(string: urlString)
//        var locationName:String?
//        var temperature: Double?
//        //чужой код
////        var errorHasOccured: Bool = false
//
//        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//                    as! [String:AnyObject]
//                //чужой код
////                if let _ = json["error"] {
////                                    errorHasOccured = true
////                                }
//                if let location = json["location"]  {
//                    locationName = location["name"] as? String
//                }
//
//                if let current = json["current"] {
//                    temperature = current["temperature"] as? Double
//
//                }
//
//            }
//            catch let jsonError {
//                print(jsonError)
//            }
//        }
//        task.resume()
//    }
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        let keyString = "bd6f8467683e4281ba5172555190902"
        let txtString = searchBar.text!.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://api.apixu.com/v1/current.json?key=\(keyString)&q=\(txtString)"
        
        var locationName: String?
        var temperature: Double?
        var errorHasOccured: Bool = false
        
        guard let url = URL(string: urlString) else{
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, err) in
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    as! [String:AnyObject]
            
                if let _ = json["error"] {
                    errorHasOccured = true
                }
            
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
            
                if let current = json["current"] {
                    temperature = current["temp_c"] as? Double
                }
            
                DispatchQueue.main.async {
                    if errorHasOccured {
                        self?.cityLabel.text = "n/a"
                        self?.temperatureLabel.isHidden = true
                    } else {
                        self?.cityLabel.text = locationName
                        self?.temperatureLabel.text = "\(temperature!)"
                        self?.temperatureLabel.isHidden = false
                    }
                }
            }
            catch let jsonError {
                print(jsonError)
            }
            
        }.resume()
        
    }


}


