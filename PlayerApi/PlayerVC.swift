//
//  PlayerVC.swift
//  PlayerApi
//
//  Created by Neha Penkalkar on 11/04/21.
//

import UIKit

class PlayerVC: UIViewController{
    var countryNameDict = NSDictionary()
    var countryName = ""
    var playerNameArr = [NSDictionary]()
    
    @IBOutlet weak var playerTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
    }
    
    
    func apiCall(){
        URLSession.shared.dataTask(with: URL(string: "http://test.oye.direct/players.json")!) { (data, resp, err) in
            
            if let error = err{
                print("Error is \(error.localizedDescription)")
                return
            }
            
            if let dataResp = data{
                do{
                    let jsonResp = try JSONSerialization.jsonObject(with: dataResp, options: .mutableLeaves) as! NSDictionary
                    self.countryNameDict = jsonResp
                    self.playerNameArr = self.countryNameDict.value(forKey: "\(self.countryName)") as! [NSDictionary]
                    
                    print(self.playerNameArr)
                    
                    DispatchQueue.main.async {
                        self.playerTV.reloadData()
                    }
                    
                }catch{
                    
                }
            }
        }.resume()
    }
    
    @IBAction func sortNameBtn(_ sender: Any) {
        let sorted = playerNameArr.sort { left, right -> Bool in
            guard let rightKey = right["name"] as? String else { return true }
            guard let leftKey = left["name"] as? String else { return false }
            return leftKey < rightKey
        }
        
        DispatchQueue.main.async {
            self.playerTV.reloadData()
        }
    }
}

extension PlayerVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = countryNameDict.value(forKey: "\(countryName)") as! [NSDictionary]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTVC") as! PlayerTVC
        //let arr = countryNameDict.value(forKey: "\(countryName)") as! [NSDictionary]
        let arr1 = playerNameArr[indexPath.row]
        cell.PlayerLbl.text = arr1.value(forKey: "name") as? String ?? ""
        
        let cap = arr1.value(forKey: "captain")
        if cap as? Int == 1 {
            cell.PlayerLbl.text = "\(arr1.value(forKey: "name") as? String ?? "") (Captain)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

class PlayerTVC: UITableViewCell{
    
    @IBOutlet weak var PlayerLbl: UILabel!
    
}
