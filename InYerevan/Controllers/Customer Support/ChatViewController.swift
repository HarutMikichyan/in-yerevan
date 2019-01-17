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
    
    // MARK:- FIREBASE PROPERTIES
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference().child("Channels")
    private var reference: CollectionReference?
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    
    // MARK:- OTHER PROPERTIES
    
    var channel: Channel!
    private var isSendingPhoto = false {
        didSet {
            DispatchQueue.main.async {
                self.messageInputBar.leftStackViewItems.forEach { item in
                    (item as! InputBarButtonItem).isEnabled = !self.isSendingPhoto
                }
            }
        }
    }
    
    // MARK:- VIEW LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
        configureLayoutAndDataSource()
        configureMessageInputBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if User.isAdministration {
            channel.isUnseenBySupport = false
            db.collection("channels").document(channel.id!).setData(["unseen": false], merge: true)
        }
    }
    
    deinit {
        messageListener?.remove()
    }
    
    // MARK:- ACTIONS
    
    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            
        }
        present(picker, animated: true, completion: nil)
    }
    
    @objc private func photosButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
        } else {
            
        }
        present(picker, animated: true, completion: nil)
    }
    
    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true
        uploadImage(image, to: channel) { [weak self] url in
            guard let `self` = self else { return }
            self.isSendingPhoto = false
            guard let url = url else { return }
            var message = Message(image: image)
            message.downloadURL = url
            self.save(message)
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    // MARK:- INITIAL CONFIGURATION METHODS
    
    private func configureDatabase() {
        guard let id = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        reference = db.collection(["channels", id, "thread"].joined(separator: "/"))
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    private func configureLayoutAndDataSource() {
        navigationItem.largeTitleDisplayMode = .never
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        messagesCollectionView.backgroundColor = UIColor.clear
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingMessagePadding(UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 50))
            layout.setMessageOutgoingMessagePadding(UIEdgeInsets(top: 0, left: 50, bottom: 0, right: -15))
        }
    }
    
    private func configureMessageInputBar() {
        // Configuring input bar
        messageInputBar.delegate = self
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.textColor = .white
        messageInputBar.inputTextView.keyboardAppearance = .dark
        messageInputBar.inputTextView.placeholderTextColor = .placeholderWhite
        messageInputBar.inputTextView.placeholder = "Type a message..."
        messageInputBar.backgroundView.backgroundColor = .inputBarDarkCerulian
        messageInputBar.shouldAutoUpdateMaxTextViewHeight = false
        messageInputBar.maxTextViewHeight = 100
            
        // Configuring camera item
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        cameraItem.tintColor = .outgoingLavender
        cameraItem.image = #imageLiteral(resourceName: "camera")
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .primaryActionTriggered
        )
        
        // Configuring photos item
        let photosItem = InputBarButtonItem(type: .system)
        photosItem.setSize(CGSize(width: 60, height: 30), animated: false)
        photosItem.tintColor = .outgoingLavender
        photosItem.image = #imageLiteral(resourceName: "picture")
        photosItem.addTarget(
            self,
            action: #selector(photosButtonPressed),
            for: .primaryActionTriggered
        )
        
        // Configuring send button item
        let sendItem = InputBarButtonItem(type: .system)
        sendItem.setSize(CGSize(width: 60, height: 30), animated: false)
        sendItem.tintColor = .outgoingLavender
        sendItem.image = #imageLiteral(resourceName: "sendMessage")
        sendItem.isEnabled = false
        sendItem.addTarget(
            self,
            action: #selector(send),
            for: .primaryActionTriggered
        )
        
        // Configuring all stack view items
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.rightStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 90, animated: false)
        messageInputBar.setStackViewItems([cameraItem, photosItem], forStack: .left, animated: false)
        messageInputBar.setStackViewItems([sendItem], forStack: .right, animated: false)
    }
    
    // MARK:- HELPER METHODS
    
    @objc private func send() {
        if !messageInputBar.inputTextView.text.isEmpty {
            messageInputBar.didSelectSendButton()
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard var message = Message(document: change.document) else { return }
        switch change.type {
        case .added:
            if let url = message.downloadURL {
                downloadImage(at: url) { [weak self] image in
                    guard let self = self else { return }
                    guard let image = image else { return }
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
        
        channel.lastMessageSentDate = message.sentDate
        db.collection("channels").document(channel.id!).setData(["lastMessageSent": message.sentDate], merge: true)
        
        if !User.isAdministration {
            channel.isUnseenBySupport = true
            db.collection("channels").document(channel.id!).setData(["unseen": true], merge: true)
        }
        
        var lastMessage = ""
        switch message.kind {
        case .emoji:
            lastMessage = message.sender.isAdministration() ? "You: " + message.emoji! : message.emoji!
        case .photo:
            lastMessage = message.sender.isAdministration() ? "You sent a picture." :
            "\(channel.name) sent you a picture."
        default:
            lastMessage = message.sender.isAdministration() ? "You: " + message.content : message.content
        }
        channel.lastMessagePreview = lastMessage
        db.collection("channels").document(channel.id!).setData(["lastMessage": lastMessage], merge: true)
        
        
        reference?.addDocument(data: message.representation) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
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

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        switch message.kind {
        case .emoji:
            return .clear
        default:
            return isFromCurrentSender(message: message) ? .outgoingLavender : .incomingDarkCerulian
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
}

// MARK: - MESSAGES DATA SOURCE

extension ChatViewController: MessagesDataSource {
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: User.email, displayName: User.email)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
}

// MARK: - MESSAGE INPUT BAR DELEGATE

extension ChatViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        text.containsOnlyEmoji ? save(Message(emoji: text)) : save(Message(content: text))
        inputBar.inputTextView.text = ""
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, textViewTextDidChangeTo text: String) {
        let sendItem = InputBarButtonItem(type: .system)
        sendItem.setSize(CGSize(width: 60, height: 30), animated: false)
        sendItem.tintColor = .outgoingLavender
        sendItem.image = #imageLiteral(resourceName: "sendMessage")
        sendItem.addTarget(
            self,
            action: #selector(send),
            for: .primaryActionTriggered
        )
        sendItem.isEnabled = !text.isEmpty
        messageInputBar.setStackViewItems([sendItem], forStack: .right, animated: false)
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
