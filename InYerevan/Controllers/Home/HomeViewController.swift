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

    // MARK:- INTERFACE BUILDER OUTLETS

    @IBOutlet weak var courseUSD: UILabel!
    @IBOutlet weak var courseRUR: UILabel!
    @IBOutlet weak var courseEUR: UILabel!
    @IBOutlet weak var weatherYerevan: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var onlineSupportButton: UIButton!
    
    // MARK:- OTHER PROPERTIES

    private var name = User.email
    private var channels = [Channel]()
    private let db = Firestore.firestore()
    private var channelListener: ListenerRegistration?
    private var channelReference: CollectionReference {
        return db.collection("channels")
    }

    // MARK:- VIEW LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .outgoingLavender

        profileButton.layer.cornerRadius = 12
        profileButton.layer.masksToBounds = true

        onlineSupportButton.layer.cornerRadius = 12
        onlineSupportButton.layer.masksToBounds = true

        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        
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
    
    // MARK:- ACTIONS

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
    
    // MARK:- PRIVATE METHODS

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
    
    deinit {
        channelListener?.remove()
    }
}
