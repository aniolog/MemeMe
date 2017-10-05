//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Carlos Lozano on 8/21/17.
//  Copyright © 2017 Carlos Lozano. All rights reserved.
//

import UIKit



class MemesCollectionViewController: UICollectionViewController {
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    
    let reuseIdentifier = "collectionCell"
    
    let space: CGFloat = 1.0
    
    var memes = [Meme]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI(appIsInLandscape: UIDevice.current.orientation.isLandscape)
        NotificationCenter.default.addObserver(self, selector: #selector(chanceFlowLayOut), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memes = (UIApplication.shared.delegate as! AppDelegate).memes
    
        collectionView!.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        cell.memedImage.image = memes[(indexPath as NSIndexPath).row].memedImage
        return cell
        
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.detailMeme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func chanceFlowLayOut(){
        prepareUI(appIsInLandscape: UIDevice.current.orientation.isLandscape)
        
    }
    
    func prepareUI(appIsInLandscape : Bool){
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        
        if(appIsInLandscape){
            let dimensionWidth  = (view.frame.size.width - (2 * space)) / 3.0
            let dimensionHeight = (view.frame.size.height - (2 * space)) / 3.0
            flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
            
        }else{
            let dimensionWidth  = (view.frame.size.width - (2 * space)) / 3.0
            let dimensionHeight = (view.frame.size.height - (2 * space)) / 2.0
            flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
        }
        
        
        
    
    
    }
    
    
    
}
