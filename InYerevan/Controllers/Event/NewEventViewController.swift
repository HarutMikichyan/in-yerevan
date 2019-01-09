//
//  NewEventViewController.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/21/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController {
    static let id = "NewEventViewController"
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dateFIeld: DatePickerInputTextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var locationFIeld: UIMapInputTextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var coverButton: UIButton!
    
    
    var images = [UIImage]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    // MARK: - Keyboard Notification handler 
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            if scrollView.contentSize.height < view.bounds.height {
                scrollView.contentSize.height += keyboardSize.height
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if scrollView.contentSize.height > view.bounds.height {
                scrollView.contentSize.height -= keyboardSize.height
            }
        }
    }
    
    // MARK: - button actions
    @IBAction func coverSelectAction(_ sender: UIButton) {
        let vc = ImagePickerViewController()
        present(vc, animated: true, completion: nil)
        vc.delegate = self
    }
    
    @IBAction func todayAction() {
        dateFIeld.setToday()
    }
    
    @IBAction func currentLocationAction() {
        
    }
    
    @IBAction func saveAction() {
        
        UIApplication.appDelegate.dataManager.saveEvent(title: titleField.text!, date: dateFIeld.getValue(), cover: images[0], pictures: images, details: descriptionTextView.text!, coordinates: locationFIeld.getCoordinatesAsTuple())
    }
    
    
}

extension NewEventViewController: NewEventCollectionViewCellWithPictureDelegate{
    func didDeleteCell(with indexPath: IndexPath) {
        images.remove(at: indexPath.row - 1 )
        imagesCollectionView.reloadData()
    }
}

extension NewEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImportImages", for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewEventCollectionViewCellWithPicture.id, for: indexPath) as! NewEventCollectionViewCellWithPicture
        cell.delegate = self
        cell.prepareCellWith(indexPath: indexPath, image: images[indexPath.row - 1 ]) // TODO: Fix Nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print()
        // open import Images
        default:
            print()
            // open image full screen somehow :D
        }
    }
}

extension NewEventViewController: ImagePickerViewControllerDelegate {
    func didSelected(image: UIImage?) {
        if image != nil {
            images.append(image!)
            imagesCollectionView.reloadData()
        }
    }
}

