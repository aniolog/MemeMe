//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Carlos Lozano on 8/21/17.
//  Copyright © 2017 Carlos Lozano. All rights reserved.
//

import UIKit


class MemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let reuseIdentifier = "tableCell"
    
    var memes = [Meme]()
    
    @IBOutlet weak var memeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memes = (UIApplication.shared.delegate as! AppDelegate).memes
        memeTableView.reloadData()
        
    }
    
   
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count;
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MemeTableViewCell
        
        cell.memedImage.image =  memes[indexPath.row].memedImage
        
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.detailMeme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    
}
