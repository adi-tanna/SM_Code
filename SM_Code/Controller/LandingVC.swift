//
//  ViewController.swift
//  SM_Code
//
//  Created by Aditya Tanna on 11/23/16.
//  Copyright © 2016 Tanna Inc. All rights reserved.
//

import UIKit
import Alamofire

class LandingVC: UICollectionViewController {
    
    @IBOutlet var collectionEmoji: UICollectionView!
   
    var arrEmojiData = [[String: String]] ()
    
    var selectedIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callWS()
    }
    
    func callWS() {
        let url = "https://api.github.com/emojis"
        
        if Reachability.isConnectedToNetwork() {
            
            ShowActivity.showActivityIndicatorOnView(view: self.view)
            
            Alamofire.request(url).responseJSON { response in
                
                ShowActivity.hideActivityIndicator()
                
                if let JSON = response.result.value {
                    
                    ShowActivity.hideActivityIndicator()
                    
                    for (name, url) in JSON as! [String: String]{
                        
                        let dictEmojiDetails = ["name":name,"url":url]
                        
                        self.arrEmojiData.append(dictEmojiDetails)
                    }
                    
                    self.collectionEmoji.reloadData()
                }
            }
        }else{
            let alert = showAlert(alertMsg: "Opps!! Looks like you're not connected to Internet")
            
            self.present(alert, animated: true, completion: { 
                
            })
        }
    }

     //MARK: ColletionView Delegate & DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrEmojiData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellEmoji = collectionView.dequeueReusableCell(withReuseIdentifier: "cellEmoji", for: indexPath)
        
        let imgViewEmoji = cellEmoji.contentView.viewWithTag(100) as! UIImageView
        
        let strImgUrl = (arrEmojiData[indexPath.item])["url"]
        
        imgViewEmoji.sd_setImage(with: URL(string: strImgUrl!), placeholderImage: UIImage(named: "place_holder@2x.png"), options: [.continueInBackground, .avoidAutoSetImage])
        
        imgViewEmoji.contentMode = .scaleAspectFit
        
        return cellEmoji
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath
        
        performSegue(withIdentifier: "segueDetailEmoji", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetailEmoji"{
            
            let objDetailEmojiVC = segue.destination as!EmojiDetailVC
            
            objDetailEmojiVC.dictEmojiDetaail = arrEmojiData[(selectedIndex?.item)!]
        }
    }
}
