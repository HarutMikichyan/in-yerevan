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
    func didSelectedItem(image: UIImage?) 
    func didDeselectedItem(image: UIImage?) 
}

class ImagePickerViewController: UIViewController {
    static let id = "ImagePickerViewController"
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var dismissView: UIView!
    
    // MARK: - Variables
    private var images = [UIImage?]()
    weak var delegate: ImagePickerViewControllerDelegate?
    private var selectedIndexPaths = Set<IndexPath>()
    
    // MARK: - LifeCycle 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    } 

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthIfNeeded()
        fetchImages()
        imageCollectionView.register(UINib(nibName: ImagePickerCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: ImagePickerCollectionViewCell.id)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        dismissView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndexPaths.removeAll()
    }
    
    // MARK: - PRIVATE INTERFACE 
    private func configure() {
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = .clear
    }
    
    @IBAction func tapOnView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchImages() {
        let queue = DispatchQueue(label: "Fetch Image", qos: .userInteractive, attributes: .concurrent)
        queue.async { [weak self] in 
            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            requestOptions.deliveryMode = .fastFormat // with larger format makes memmory leak
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
            } else { // When Count == 0 
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
        let isSelected = selectedIndexPaths.contains(indexPath)
        cell.changeCheckMarkStatus(isSelected: !isSelected)
        cell.backgroundImageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vibration = UIImpactFeedbackGenerator(style: .heavy)
        vibration.impactOccurred()
        let cell = collectionView.cellForItem(at: indexPath) as! ImagePickerCollectionViewCell
        let isSelected = selectedIndexPaths.contains(indexPath)
        cell.changeCheckMarkStatus(isSelected: isSelected)
        if  !isSelected {
            delegate?.didSelectedItem(image: images[indexPath.row])
            selectedIndexPaths.insert(indexPath)
        } else {
            delegate?.didDeselectedItem(image: images[indexPath.row])
            selectedIndexPaths.remove(indexPath) 
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height =  collectionView.bounds.height / 2 - 6 
        let width = height / 4 * 3
        return CGSize(width: width, height: height)
    }
}
