//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Carlos Lozano on 8/22/17.
//  Copyright © 2017 Carlos Lozano. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var detailMeme: Meme?
    
    @IBOutlet weak var memedImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memedImage.image = detailMeme?.memedImage
    }
    

}
