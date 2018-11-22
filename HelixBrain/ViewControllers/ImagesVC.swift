//
//  ImagesVC.swift
//  HelixBrain
//
//  Created by Emmanuel  Ogbewe on 11/21/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import Foundation
import Photos

public class ImageCell :  UICollectionViewCell{
     let imageView = UIImageView()
    
    func setUp(cellImage : UIImage){
        self.addSubview(imageView)
        imageView.image = cellImage
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ].forEach{$0.isActive = true}
        
    }
}
public class ImagesVC : UIViewController, AVSpeechSynthesizerDelegate {
    
    var collectionView : UICollectionView!
    
    var imageArray = [UIImage]()
    
    var speechHelper = SpeechHelper()
    var imageClassifier = ImageClassificationHelper()
    
    var backButton : UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "chatty_back"), for: .normal)
        b.frame.size = CGSize(width: 20, height: 20)
        return b
    }()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        layout()
        getPhotosFromAlbum()
        addTargets()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        speechHelper.startReading(text: "Hi,select and image and I will recognize what it is", delegate: self)
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    private func layout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        view.backgroundColor = UIColor(rgb: 0x0C0D0E)
        view.addSubview(collectionView)
        view.addSubview(backButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        [
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 15)
            ].forEach{$0.isActive = true}
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        [
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ].forEach{$0.isActive = true}
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    private func addTargets(){
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
    }
    @objc private func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func getPhotosFromAlbum() {
        
        let imageManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            
            for i in 0..<fetchResult.count {
                
                imageManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, error in
                    
                    self.imageArray.append(image!)
                })
            }
            print(imageArray.count)
        } else {
            self.collectionView.reloadData()
        }
    }
    private func selectImage(image: UIImage){
        let string = imageClassifier.imageToText(forImage: image)
        speechHelper.startReading(text: string!, delegate: self)
      
    }
    private func animateImage(image: UIImageView){
        image.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 1, delay: 0,usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(2.0), options: .curveEaseOut, animations: {
                        image.transform = CGAffineTransform.identity
        }) { (bool) in
            print(true)
        }
    }
}
extension ImagesVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.setUp(cellImage: imageArray[indexPath.item])
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = imageArray[indexPath.item]
        let newImage = image.resize(withWidth: 224)
        let cellImageView = collectionView.cellForItem(at: indexPath) as! ImageCell
        selectImage(image: newImage!)
        animateImage(image: cellImageView.imageView)
        
    }
    //Collection view layout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
extension UIImage {
    
    func resize(withWidth newWidth: CGFloat) -> UIImage? {
        
//        let scale = newWidth / self.size.width
//        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
