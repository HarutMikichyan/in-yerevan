//
//  ImagePickerViewController.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/28/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Photos

protocol ImagePickerViewControllerDelegate: class {
    func didSelected(image: UIImage?) 
}

class ImagePickerViewController: UIViewController {
    static let id = "ImagePickerViewController"
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    // MARK: - Variables
    private var images = [UIImage?]()
    weak var delegate: ImagePickerViewControllerDelegate?
    
    // MARK: - LifeCycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen
        PHPhotoLibrary.requestAuthIfNeeded()
        fetchImages()
        imageCollectionView.register(UINib(nibName: ImagePickerCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: ImagePickerCollectionViewCell.id)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
    }
    
    // MARK: - PRIVATE INTERFACE 
    
    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchImages() {
        
        let queue = DispatchQueue(label: "Fetch Image", qos: .userInteractive, attributes: .concurrent)
        
        queue.async { [weak self] in 
            
            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            
            requestOptions.deliveryMode = .fastFormat
            
            let fetchOptions = PHFetchOptions()
            
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            if fetchResult.count > 0 {
                self?.images = []
                for i in 0..<fetchResult.count {
                    imageManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width:500, height: 500), contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self?.images.append(image)
                        DispatchQueue.main.async {
                            self?.imageCollectionView.reloadData()
                        }
                    })
                }
                
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "No Photos", message: "you Don't have any Photo on your device", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
}

extension ImagePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionViewCell.id, for: indexPath) as! ImagePickerCollectionViewCell
        cell.backgroundImageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vibration = UIImpactFeedbackGenerator(style: .heavy)
        vibration.impactOccurred()
        delegate?.didSelected(image: images[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.bounds.height / 2 - 6
        return CGSize(width: side, height: side)
    }
    
    
}
