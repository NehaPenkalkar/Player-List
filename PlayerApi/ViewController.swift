import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    var countryNameDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
    }
    
    func apiCall(){
        URLSession.shared.dataTask(with: URL(string: "http://test.oye.direct/players.json")!) { (data, resp, err) in
            print("Response \n Data:-\(data) \n Response:- \(resp) \n Error:- \(err)")
            
            if let error = err{
                print("Error is \(error.localizedDescription)")
                return
            }
            
            if let dataResp = data{
                do{
                    let jsonResp = try JSONSerialization.jsonObject(with: dataResp, options: .mutableLeaves) as! NSDictionary
                    self.countryNameDict = jsonResp
                    
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                    
                }catch{
                    
                }
            }
        }.resume()
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryNameDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTVC") as! CustomTVC
        cell.countryLbl.text = "\(countryNameDict.allKeys[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerVC
        vc.countryName = "\(countryNameDict.allKeys[indexPath.row])"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "customHeader") as! customHeader
        header.headLbl.text = "List of Playing Countries"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}


class customHeader: UITableViewCell{
    
    @IBOutlet weak var headLbl: UILabel!
}
