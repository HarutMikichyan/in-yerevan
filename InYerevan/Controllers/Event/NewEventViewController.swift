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
    @IBOutlet weak var categoryField: TextPickerInputTextField!
    
    
    var images = [UIImage]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Event"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        if let categories = UIApplication.dataManager.fetchCategories() {
            categoryField.rowContents.removeAll()
            for category in categories {
                categoryField.rowContents.insert(category.name!)
            }
        }
        
    }
    
    
    // MARK: - Keyboard Notification handler 
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
    // MARK: - BUTTONS
    @IBAction func todayAction() {
        dateFIeld.setTommorow()
    }
    
    @IBAction func currentLocationAction() {
        locationFIeld.setCurrentLocation()
    }
    
    @IBAction func newCategoryAction() {
        let alert = UIAlertController(title: "New Category", message: "Enter name of categorty and pres OK", preferredStyle: .alert)
        var textField = UITextField()
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            if !textField.text!.isEmpty {
                UIApplication.dataManager.newCategoryWith(name: textField.text!, completion: { (category) in
                    self.categoryField.rowContents.insert(category.name!)
                    self.categoryField.text = category.name!
                   
                })  
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addTextField { (field) in
            textField = field
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveAction() {
        UIApplication.dataManager.saveEvent(title: titleField.text!, date: dateFIeld.getValue(), category: categoryField.text!, pictures: images , details: descriptionTextView.text!, coordinates: locationFIeld.getCoordinatesAsTuple())
        navigationController?.popViewController(animated: true)
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
        cell.prepareCellWith(indexPath: indexPath, image: images[indexPath.row - 1 ])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.bounds.height - 8
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = ImagePickerViewController()
            present(vc, animated: true, completion: nil)
            vc.delegate = self
        }
    }
}

extension NewEventViewController: ImagePickerViewControllerDelegate {
    func didSelectedItem(image: UIImage?) {
        if image != nil {
            images.append(image!)
            imagesCollectionView.reloadData()
        }
    }

    func didDeselectedItem(image: UIImage?) {
        if image != nil {
            for index in 0..<images.count {
                if image! == images[index] {
                    images.remove(at: index)
                    imagesCollectionView.reloadData()
                    break
                }
            } 
        }
    }
    
}

