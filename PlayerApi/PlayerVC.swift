//
//  PlayerVC.swift
//  PlayerApi
//
//  Created by Neha Penkalkar on 11/04/21.
//

import UIKit

class PlayerVC: UIViewController{
    var countryNameDict = NSDictionary()
    
    @IBOutlet weak var playerTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
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
                    
                    DispatchQueue.main.async {
                        self.playerTV.reloadData()
                    }
                    
                }catch{
                    
                }
            }
        }.resume()
    }
}

extension PlayerVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = #colorLiteral(red: 0.4739587903, green: 0.5093277097, blue: 0.6873951554, alpha: 1)
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let arr = countryNameDict.value(forKey: "India") as! [NSDictionary]
        let demo = arr[indexPath.row]
        cell.textLabel?.text = demo.value(forKey: "name") as? String ?? ""
        print("Source Tree testing")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
