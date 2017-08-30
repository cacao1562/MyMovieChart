

import UIKit
import MapKit

class TheaterViewController: UIViewController {

   
   
    @IBOutlet var map: MKMapView!
    
    
    
    var param : NSDictionary!
       
    override func viewDidLoad() {
       // var navibar = navigationItem.title
       // navibar = self.param["상영관명"] as? String
        
        self.navigationItem.title = self.param["상영관명"] as? String
        
        
        
        
        //string타입으로 전달되는데 NSString 객체는 문자열을 Double타입으로 변환해주는 doubleValue 속성이 있어서 NSString 타입으로 캐스팅함
        let lat = (param?["위도"] as! NSString).doubleValue
        let lng = (param?["경도"] as! NSString).doubleValue
        
        //위도와 경도를 이용해 2D 객체생성 중심좌표
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        //지역의 너비 m미터 단위 축척값
        let regionRadius: CLLocationDistance = 100
        
        //중심좌표와 가로,세로 
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
        
        self.map.setRegion(coordinateRegion, animated: true)
        
        let point = MKPointAnnotation()  //위치 포인터
        point.coordinate = location     //핀 모양
        
        self.map.addAnnotation(point)
    }
}
