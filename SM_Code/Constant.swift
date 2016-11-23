//
//  Constant.swift
//  SM_Code
//
//  Created by Aditya Tanna on 11/23/16.
//  Copyright © 2016 Tanna Inc. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration

public class Constant: NSObject {
   
}

public func showAlert(alertMsg: String) -> UIAlertController {
    let alert = UIAlertController(title: "", message: alertMsg, preferredStyle: UIAlertControllerStyle.alert)
    
    let alertActionOk = UIAlertAction(title: "Ok", style: .default, handler: { void in
        
    });
    
    alert.addAction(alertActionOk)
    
    return alert
}

//MARK: Common Web Service call & Show & Hide Activity Indicator with message
public func callWebService(_ url: String, parameters: [String: AnyObject], methodHttp: HTTPMethod , completion: @escaping (_ result: AnyObject) -> Void, failure: @escaping (_ result: AnyObject) -> Void) {
    
    Alamofire.request(url, method: methodHttp, parameters: parameters , encoding: JSONEncoding.default).responseJSON { (response) in
        
        ShowActivity.hideActivityIndicator()
        
        if let status = response.response?.statusCode {
            switch(status){
            case 200:
                print("Status code : \(status)")
                
            case 201:
                print("Status code : \(status)")
            default:
                print("Status code : \(status)")
            }
        }
        
        switch( response.result){
        case .failure(let error):
            print(error)
            
            let jsonDictionary = error as? [String:AnyObject]
            
            print("\(jsonDictionary! as [String:AnyObject])")
            
            failure(jsonDictionary! as AnyObject)
            
        case .success(let json):
            
            let response = json as! NSDictionary
            
            let jsonDictionary = response.object(forKey: "Result") as! NSDictionary
            
            completion(jsonDictionary)
        }
    }
}

public class ShowActivity: NSObject {
    
    static var viewActivity:UIView!
    static var indicator:UIActivityIndicatorView?

    class func showActivityIndicatorOnView(view:UIView) {
        
        if((self.viewActivity == nil)){
            viewActivity = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            viewActivity.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
            indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            indicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            indicator?.startAnimating()
            
            let lbl:UILabel = UILabel(frame: CGRect(x: 3, y: 0, width: (viewActivity.frame.size.width) - 6, height: 30))
            lbl.numberOfLines = 0
            lbl.backgroundColor = UIColor.clear
            lbl.textColor = UIColor.white
            lbl.font = UIFont(name: "HelveticaNeue", size: 15.0)
            lbl.textAlignment = NSTextAlignment.center
            lbl.text = "Loading..."
            
            indicator!.center = CGPoint(x: (viewActivity.center.x), y: (viewActivity.center.y) - ((indicator?.frame.size.height)! / 4))
            
            lbl.center = CGPoint(x: (viewActivity.center.x), y: (indicator?.frame)!.maxY + ((indicator?.frame.size.height)! / 4))
            
            viewActivity.addSubview(lbl)
        }else{
            indicator?.center = (viewActivity.center)
        }
        
        viewActivity.addSubview(indicator!)
        viewActivity.layer.cornerRadius = 10
        
        viewActivity.center = view.center
        
        view.addSubview(viewActivity)
    }
    
    class func hideActivityIndicator(){
        if(viewActivity != nil){
            indicator?.stopAnimating()
            viewActivity.removeFromSuperview()
            indicator = nil
            viewActivity = nil
        }
    }
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
