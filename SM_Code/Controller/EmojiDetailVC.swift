//
//  EmojiDetailVC.swift
//  SM_Code
//
//  Created by Aditya Tanna on 11/23/16.
//  Copyright © 2016 Tanna Inc. All rights reserved.
//

import UIKit

class EmojiDetailVC: UIViewController {

    @IBOutlet var imgEmoji: UIImageView!
    
    @IBOutlet var lblEmojiName: UILabel!
    
    var dictEmojiDetaail : [String: String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgEmoji.sd_setImage(with: URL(string: (dictEmojiDetaail?["url"])!), placeholderImage: UIImage(named: "place_holder@2x.png"), options: [.continueInBackground, .avoidAutoSetImage])
        
        lblEmojiName.text = (dictEmojiDetaail?["name"])!

    }
}
