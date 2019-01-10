//
//  ChatViewController.swift
//  In Yerevan
//
//  Created by Vahram Tadevosian on 12/25/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import MessageKit
import MessageInputBar
import Photos

final class ChatViewController: MessagesViewController {
    
    // MARK:- MAIN PROPERTIES
    
    var channel: Channel!
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private var reference: CollectionReference?
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    
    private var isSendingPhoto = false {
        didSet {
            DispatchQueue.main.async {
                /// ----------------------------------------------- /// subject to change
                
                self.messageInputBar.leftStackViewItems.forEach { item in
                    (item as! InputBarButtonItem).isEnabled = !self.isSendingPhoto
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        reference = db.collection(["channels", id, "thread"].joined(separator: "/"))
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        navigationItem.largeTitleDisplayMode = .never
        
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .gray
        messageInputBar.sendButton.setTitleColor(.gray, for: .normal)
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
        
        // 1
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .blue
        cameraItem.image = #imageLiteral(resourceName: "camera")
        let photosItem = InputBarButtonItem(type: .system)
        photosItem.tintColor = .blue
        photosItem.image = #imageLiteral(resourceName: "photos")
        
        messageInputBar.sendButton.tintColor = .blue
        messageInputBar.sendButton.image = #imageLiteral(resourceName: "sendMessage")
        // 2
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .primaryActionTriggered
        )
        photosItem.addTarget(
            self,
            action: #selector(photosButtonPressed),
            for: .primaryActionTriggered
        )
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        photosItem.setSize(CGSize(width: 60, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 90, animated: false)
        
        // 3
        messageInputBar.setStackViewItems([cameraItem, photosItem], forStack: .left, animated: false)
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingMessagePadding(UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0))
            layout.setMessageOutgoingMessagePadding(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20))
        }
    }
    
    deinit {
        /// ----------------------------------------------- /// subject to change
        messageListener?.remove()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if User.isAdministration {
            channel.numberOfUnreadMessages = 0
            db.collection("channels").document(channel.id!).setData(["unreadMessages": 0], merge: true)
        }
    }
    
    
    
    // MARK:- ACTIONS
    
    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        /// ----------------------------------------------- /// subject to change
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            /// to change
        }
        present(picker, animated: true, completion: nil)
    }
    
    @objc private func photosButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        /// ----------------------------------------------- /// subject to change
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
        } else {
            /// to change
        }
        present(picker, animated: true, completion: nil)
    }
    
    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true
        uploadImage(image, to: channel) { [weak self] url in
            guard let `self` = self else {
                return
            }
            self.isSendingPhoto = false
            
            guard let url = url else {
                return
            }
            
            var message = Message(image: image)
            message.downloadURL = url
            self.save(message)
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.index(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    // MARK:- HELPER FUNCTIONS
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard var message = Message(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            if let url = message.downloadURL {
                downloadImage(at: url) { [weak self] image in
                    guard let self = self else {
                        return
                    }
                    guard let image = image else {
                        return
                    }
                    
                    message.image = image
                    self.insertNewMessage(message)
                }
            } else if message.content.containsOnlyEmoji {
                message.emoji = message.content
                insertNewMessage(message)
            } else {
                insertNewMessage(message)
            }
            
        default:
            break
        }
    }
    
    private func save(_ message: Message) {
        if !User.isAdministration {
            let unreadMessages = channel.numberOfUnreadMessages ?? 0
            channel.numberOfUnreadMessages = unreadMessages + 1
            db.collection("channels").document(channel.id!).setData(["unreadMessages": (unreadMessages + 1)], merge: true)
        }
        reference?.addDocument(data: message.representation) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func uploadImage(_ image: UIImage, to channel: Channel, completion: @escaping (URL?) -> Void) {
        guard let channelID = channel.id else {
            completion(nil)
            return
        }
        
        guard let scaledImage = image.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: 0.4) else {
                completion(nil)
                return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        storage.child(channelID).child(imageName).putData(data, metadata: metadata) { meta, error in
            if let error = error {
                print(error)
            }
            
            self.storage.child(channelID).child(imageName).downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error as Any)
                } else {
                    guard let imageURL = url?.absoluteURL else { return }
                    completion(imageURL)
                }
                
            })
        }
    }
    
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: imageData))
        }
    }
    
}

// MARK: - MESSAGES DISPLAY DELEGATE

extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        switch message.kind {
        case .emoji:
            return .clear
        default:
            return isFromCurrentSender(message: message) ? .gray : .cyan
        }
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
}

// MARK: - MESSAGES LAYOUT DELEGATE

extension ChatViewController: MessagesLayoutDelegate {
    
}

// MARK: - MESSAGES DATA SOURCE

extension ChatViewController: MessagesDataSource {
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: User.email, displayName: ChatSettings.displayName)
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
    
}

// MARK: - MESSAGE INPUT BAR DELEGATE

extension ChatViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        if text.containsOnlyEmoji {
            save(Message(emoji: text))
        } else {
            save(Message(content: text))
        }
        inputBar.inputTextView.text = ""
    }
}

// MARK: - IMAGE PICKER CONTROLLER & NAVIGATION CONTROLLER DELEGATE

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        picker.dismiss(animated: true, completion: nil)
        if let asset = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.phAsset)] as? PHAsset {
            let size = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: size,
                contentMode: .aspectFit,
                options: nil) { result, info in
                    guard let image = result else { return }
                    self.sendPhoto(image)
            }
        } else if let image = info[(convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage))] as? UIImage {
            sendPhoto(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK:- HELPER FUNCTIONS BY SWIFT 4.2 MIGRATOR

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

