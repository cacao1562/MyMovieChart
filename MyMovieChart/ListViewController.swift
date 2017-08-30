

import UIKit

class ListViewController: UITableViewController {

    var page = 1
        
    
        
        lazy var list : [MovieVO] = {
            var datalist = [MovieVO]()
            
                       return datalist
        }()
    
    @IBAction func more(_ sender: Any) {
        self.page += 1
        
        self.callMovieAPI()
        
        self.tableView.reloadData()
    }
    
    @IBOutlet var moreBtn: UIButton!
    
       
    override func viewDidLoad() {
        
        self.callMovieAPI()
        
        }
    
    
    func callMovieAPI() {
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=&order=releasedateasc"
        let apiURI : URL! = URL(string: url)
        
        let apidata = try! Data(contentsOf: apiURI)
        
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API Result=\( log )")
        
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            for row in movie {
                let r = row as! NSDictionary
                
                let mvo = MovieVO()
                
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)
                
                let url : URL! = URL(string: mvo.thumbnail!)
                let imageData = try! Data(contentsOf: url)
                mvo.thumbnailImage = UIImage(data: imageData)
                
                let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
                
                if (self.list.count >= totalCount) {
                    self.moreBtn.isHidden = true
                }
                self.list.append(mvo)
            }
        } catch {
            NSLog("Parse Error!")
        }

    }
    
    func getThumbnailImage( _ index : Int) -> UIImage {
        let mvo = self.list[index]
        
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        } else {
            let url : URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            mvo.thumbnailImage = UIImage(data: imageData)
            
            return mvo.thumbnailImage!

        }
    }
    
    //행 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.list.count
        }
    
    //반복 호출
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.list[indexPath.row]
        
        NSLog("제목:\(row.title), 호출된 행번호:\(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell //커스텀 클래스로 캐스팅
        
       /* let title = cell.viewWithTag(101) as? UILabel */ //tag로 객체 가져오는 방법
        
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        //cell.thumbnail.image = row.thumbnailImage
        
        DispatchQueue.main.async(execute: { //비동기 방식
            cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
        })
        /* let url: URL! = URL(string: row.thumbnail!)
        let imageData = try! Data(contentsOf: url)
        cell.thumbnail.image = UIImage(data:imageData)
        //한줄로 작성한것
         cell.thumbnail.image = UIImage(data: try! Data(contentsOf: URL(string: row.thumbnail!)!)) */
        
       
        return cell
    }
    
    //해당 행 선택했을때
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {  //세그웨이 전처리 메소드(화면전환 되기전 호출)
        
        if segue.identifier == "segue_detail" { //실행된 세그웨이의 식별자가 ""이라면
            
            let cell = sender as! MovieCell   //sender인자를 캐스팅하여 테이블 셀 객체로 변환
            
            let path = self.tableView.indexPath(for: cell)  //첫번째 인자값을 이용해 몇번째 행을 선택했는지 확인
            
            let movieinfo = self.list[path!.row]  //api 영화 데이터배열 중에서 선택된 행에 대한 데이터 추출
            
            let detailVC = segue.destination as? DetailViewController  //영화 데이터를 찾은다음, 목적지 뷰 컨트롤러의 mvo 변수에 대입
            
            detailVC?.mvo = movieinfo
        }
    }
        
    

}
