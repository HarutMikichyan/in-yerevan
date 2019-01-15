//
//  HomeViewController.swift
//  In Yerevan
//
//  Created by Gev Darbinyan on 17/12/2018.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet weak var onlineSupportButton: UIButton!
    
    private var name = User.email
    private let db = Firestore.firestore()
    private var channels = [Channel]()
    private var channelListener: ListenerRegistration?
    private var channelReference: CollectionReference {
        return db.collection("channels")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .outgoingLavender

        channelListener = channelReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
        if User.email == "guest" {
            onlineSupportButton.isEnabled = false
            onlineSupportButton.setTitleColor(UIColor.white, for: .normal)
            onlineSupportButton.backgroundColor = UIColor.white
        }
    }
    
    private func addChannelToTable(_ channel: Channel) {
        guard !channels.contains(channel) else { return }
        channels.append(channel)
        channels.sort()
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let channel = Channel(document: change.document) else { return }
        switch change.type {
        case .added:
            addChannelToTable(channel)
        default:
            break
        }
    }
    
    @IBAction func onlineSupportAction() {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        if User.isAdministration {
            let vc = sb.instantiateViewController(withIdentifier: "userlist") as! UserListViewController
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = sb.instantiateViewController(withIdentifier: "chatvc") as! ChatViewController
            if channels.contains(Channel(name: name)) {
                let index = channels.index(of: Channel(name: name))
                vc.channel = channels[index!]
                navigationController?.pushViewController(vc, animated: true)
            } else {
                channelReference.addDocument(data: Channel(name: name).representation) { error in
                    if let error = error {
                        print("Error saving channel: \(error.localizedDescription)")
                    }
                }
            }
            vc.title = "Customer Support"
        }
    }
    
    deinit {
        channelListener?.remove()
    }
}
