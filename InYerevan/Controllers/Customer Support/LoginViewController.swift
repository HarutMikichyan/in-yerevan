//
//  LoginViewController.swift
//  In Yerevan
//
//  Created by Vahram Tadevosian on 12/26/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//
/// used for testing

import UIKit
import Firebase
import FirebaseFirestore

final class LoginViewController: UIViewController {
    
    private let db = Firestore.firestore()
    private var channels = [Channel]()
    private var channelListener: ListenerRegistration?
    private var channelReference: CollectionReference {
        return db.collection("channels")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelListener = channelReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
        
    }
    
    private func addChannelToTable(_ channel: Channel) {
        guard !channels.contains(channel) else {
            return
        }
        channels.append(channel)
        channels.sort()
    }

    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let channel = Channel(document: change.document) else { ///-------
            return
        }
        switch change.type {
        case .added:
            addChannelToTable(channel)
        default:
            break
        }
    }
    
    
    deinit {
        channelListener?.remove()
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func textFieldEditingChanged() {
        if (usernameTextField.text?.isEmpty)! {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }
    
    @IBAction func login() {
        let name = usernameTextField.text!
        ChatSettings.displayName = name
        Auth.auth().signInAnonymously(completion: nil)
        let sb = UIStoryboard(name: "CustomerSupport", bundle: nil)
        if name != "host" {
            let vc = sb.instantiateViewController(withIdentifier: "chatvc") as! ChatViewController
            if channels.contains(Channel(name: name)) {
                let index = channels.index(of: Channel(name: name))
                vc.channel = channels[index!]
                vc.user = Auth.auth().currentUser
                navigationController?.setViewControllers([vc], animated: true)
            } else {
                channelReference.addDocument(data: Channel(name: name).representation) { error in
                    if let e = error {
                        print("Error saving channel: \(e.localizedDescription)")
                    }
                }

            }
            vc.title = "Customer Support"
//            vc.newlyCreatedChannelName = name
//            vc.shouldOpenChatInstantly = true
        } else {
            let vc = sb.instantiateViewController(withIdentifier: "userlist") as! UserListViewController
            vc.currentUser = Auth.auth().currentUser
            navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    ///---------subject to change----------///
    // MARK: - KEYBOARD FUNCTIONALITY
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        guard let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            return
        }
        
        let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
        
        UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        guard let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            return
        }
        
        let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
        
        UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    ///-----------------------------------///
    
}

