

import UIKit

class DetailViewController : UIViewController, UIWebViewDelegate {
    
    @IBOutlet var wv: UIWebView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var mvo : MovieVO!
    
    override func viewDidLoad() {
        NSLog("linkurl = \(self.mvo?.detail), title=\(self.mvo?.title)")
        
        let navibar = self.navigationItem
        navibar.title = self.mvo?.title
        
        if let url = self.mvo?.detail {
            if let urlObj = URL(string: url) {
                let req = URLRequest(url: urlObj)
                self.wv.loadRequest(req)
                
            } else {  //url 형식이 잘못되었을 경우 예외처리
                let alert = UIAlertController(title: "오류", message: "잘못된 url입니다", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel) {
                    (_) in
                    _ = self.navigationController?.popViewController(animated: true)  //이전 페이지로 이동
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: false, completion: nil)
            }
            
        } else {  //url 값이 전달되지 않았을 경우 예외처리
            let alert = UIAlertController(title: "오류", message: "필수 파라미터가 누락되었습니다", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel) {
                (_) in
                _ = self.navigationController?.popViewController(animated: true) //이전 페이지로 이동
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: false, completion: nil)

        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.spinner.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.spinner.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.spinner.stopAnimating()
        
        let alert = UIAlertController(title: "오류", message: "상세페이지를 읽어오지 못했습니다", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) {
            (_) in
            _ = self.navigationController?.popViewController(animated: true) //이전 페이지로 이동
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: false, completion: nil)

        
    }
}
