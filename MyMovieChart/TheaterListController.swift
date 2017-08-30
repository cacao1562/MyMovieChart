

import UIKit

class TheaterListController : UITableViewController {
    
    var list = [NSDictionary]()
    
    var startPoint = 0
    
    override func viewDidLoad() {
        self.callTheaterAPI()
        self.tableView.reloadData()
    }
    
    
    
    
    func callTheaterAPI() {
        
        let requestURI = "http://swiftapi.rubypaper.co.kr:2029/theater/list"
        let sList = 10
        let type = "json"
        
        let urlObj = URL(string: "\(requestURI)?s_page=\(self.startPoint)&s_List=\(sList)&type=\(type)")
        
        do {
            
            let stringdata = try NSString(contentsOf: urlObj!, encoding: 0x80_000_422)
            
            let encdata = stringdata.data(using: String.Encoding.utf8.rawValue)
            
            do {
                
                let apiArray = try JSONSerialization.jsonObject(with: encdata!, options: []) as? NSArray
                
                for obj in apiArray! {
                    self.list.append(obj as! NSDictionary)
                }
            } catch {
                let alert = UIAlertController(title: "실패", message: "데이터 분석이 실패하였습니다", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: false)
            }
            
            self.startPoint += sList
            
        } catch {
            let alert = UIAlertController(title: "실패", message: "데이터를 불러오는데 실패하였습니다", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: false)
        }
    }
    
    @IBAction func more(_ sender: Any) {
        self.startPoint += 20
        self.callTheaterAPI()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let obj = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell") as! TheaterCell
        
        cell.name?.text = obj["상영관명"] as? String
        cell.tel?.text = obj["연락처"] as? String
        cell.addr?.text = obj["소재지도로명주소"] as? String
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier=="segue_map") {
           
            //선택된 셀의 행 정보
            let path = self.tableView.indexPath(for: sender as! UITableViewCell)
            
            //선택된 셀에 사용된 데이터
            let data = self.list[path!.row]
            NSLog("///Log data value /// \n \(data)")
            //세그웨이가 이동할 목적지 뷰 컨트롤러 객체를 구하고, 선언된 param 변수에 데이터를 연결
            (segue.destination as? TheaterViewController)?.param = data
            
        }
    }
}
