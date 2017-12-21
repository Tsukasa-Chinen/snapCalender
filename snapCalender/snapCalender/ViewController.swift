//
//  ViewController.swift
//  sampleSnapShot
//
//  Created by CoComina and yuka on 2017/12/20.
//  Copyright © 2017年 yuka. All rights reserved.
//

import UIKit
import WebKit
import Photos

class ViewController: UIViewController
    ,UIWebViewDelegate
{
    // appDeligateをインスタンス化
    let appDeligate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    var capturedImage : UIImage?
    
    @IBOutlet weak var calenderWebView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderWebView.delegate = self
        appDeligate.loadFile(webViewName:calenderWebView, resource: "index", type: "html")
    }
    

    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(#function)

        if(request.url!.scheme == "scheme") {
            
            let components: NSURLComponents? = NSURLComponents(string: request.url!.absoluteString)
            for i in 0 ..< (components?.queryItems?.count)! {
                let page = (components?.queryItems?[i])! as URLQueryItem
                if page.name == "camera" {
                    snapshot()
                }
            }
            return false
        }
        return true
    }
    

    
    func snapshot() {
        capturedImage = getScreenShot() as UIImage
        UIImageWriteToSavedPhotosAlbum(capturedImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func notifyToWebView() {
		let sendMessage = "$('#js_prev, #js_next').removeClass('active');"
        calenderWebView.stringByEvaluatingJavaScript(from: sendMessage)
    }
    
    private func getScreenShot() -> UIImage {
        var heightSize:CGFloat
        
        if( UIDevice.current.userInterfaceIdiom == .pad) {
            heightSize = 582
        }
        else {
            heightSize = 430
        }
		
        let rect:CGRect = CGRect(x: 0, y: 0, width: calenderWebView.frame.width, height: heightSize)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.view.layer.render(in: context)
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
	
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
			alertAction1(s_title: "Save error", s_message: error.localizedDescription, s_action: "OK")
        } else {
			alertAction1(s_title: "Saved!", s_message: "Your altered image has been saved to your photos.", s_action: "OK")

        }
    }
    
	
    func alertAction1(s_title:String, s_message:String, s_action:String){

        //部品となるアラート
        let alert = UIAlertController(
            title: s_title ,
            message: s_message,
            preferredStyle: .alert
        )
        
        //ボタンを増やしたいときは、addActionをもう一つ作ればよい
        alert.addAction(
            UIAlertAction(
                title: s_action,
                style: .default,
                handler: {
					action in self.notifyToWebView()
					}
				)
        )
        
        // アラート表示
        present(alert, animated: true, completion: nil)
		

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

