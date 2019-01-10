//
//  UserListViewController.swift
//  In Yerevan
//
//  Created by Vahram Tadevosian on 12/25/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MessageKit

final class UserListViewController: UITableViewController {
    
    // MARK:- MAIN PROPERTIES
    
    var currentUser: User? = nil
//    var newlyCreatedChannelName: String?
//    var shouldOpenChatInstantly = false
    
    private let db = Firestore.firestore()
    private let channelCellIdentifier = "channelCell"
    
    private var channels = [Channel]()
    private var channelListener: ListenerRegistration?
    private var channelReference: CollectionReference {
        return db.collection("channels")
    }
    
    ///---------subject to change----------///
    deinit {
        channelListener?.remove()
    }
    ///-----------------------------------///

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        channelListener = channelReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }

            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
        
//        if let name = newlyCreatedChannelName {
//            let channel = Channel(name: name)
//            guard !channels.contains(channel) else {
//                return
//            }
//            createChannel(channel)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Chat List"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
//        if shouldOpenChatInstantly {
//            let sb = UIStoryboard(name: "CustomerSupport", bundle: nil)
//            let vc = sb.instantiateViewController(withIdentifier: "chatvc") as! ChatViewController
//            vc.user = currentUser
//            for channel in channels {
//                if channel.name == ChatSettings.displayName {
//                    vc.channel = channel
//                    break
//                }
//            }
//            navigationController?.setViewControllers([vc], animated: true)
//        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        newlyCreatedChannelName = nil
//    }
    
    // MARK:- ACTIONS
    
    private func createChannel(_ channel: Channel) {
        channelReference.addDocument(data: channel.representation) { error in
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let channel = Channel(document: change.document) else { ///-------
            return
        }
        switch change.type {
        case .added:
            addChannelToTable(channel)
        case .modified:
            updateChannelInTable(channel)
        case .removed:
            removeChannelFromTable(channel)
        }
    }
    
    @objc private func logOut() {
        do {
            try Auth.auth().signOut()
            print("---------SIGNED OUT----------")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
        
        navigationController?.popViewController(animated: true)
    }


// MARK :- HELPER FUNCTIONS

private func addChannelToTable(_ channel: Channel) {
    guard !channels.contains(channel) else {
        return
    }
    channels.append(channel)
    channels.sort()
    guard let index = channels.index(of: channel) else { return }
    tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
}

private func updateChannelInTable(_ channel: Channel) {
    guard let index = channels.index(of: channel) else { return }
    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
}

private func removeChannelFromTable(_ channel: Channel) {
    guard let index = channels.index(of: channel) else { return }
    channels.remove(at: index)
    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
}

}

// MARK:- TABLE VIEW DATA SOURCE
extension UserListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: channelCellIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = channels[indexPath.row].name
        return cell
    }
    
}

// MARK:- TABLE VIEW DELEGATE
extension UserListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "chatvc") as! ChatViewController
        vc.channel = channels[indexPath.row]
        vc.title = vc.channel.name
        navigationController?.pushViewController(vc, animated: true)
    }
}
