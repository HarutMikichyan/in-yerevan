//
//  ChannelCell.swift
//  InYerevan
//
//  Created by Vahram Tadevosian on 1/10/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    static let id = "ChannelCell"
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var unreadMessagesView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastMessagePreviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        unreadMessagesView.makeCircular()
        unreadMessagesView.changeBackgroundToGradient(from: [.outgoingLavender, UIColor.white])
    }
    
    weak var channel: Channel! {
        didSet {
            unreadMessagesView.isHidden = !channel.isUnseenBySupport
            chatNameLabel.text = channel.name
            lastMessagePreviewLabel.text = channel.lastMessagePreview

            let currentDate = Date()
            let dateYear = channel.lastMessageSentDate.toString().year
            let dateMonth = channel.lastMessageSentDate.toString().month
            let dateDay = channel.lastMessageSentDate.toString().day
            let dateTime = channel.lastMessageSentDate.toString().time
            
            let sentThisYear = dateYear == currentDate.toString().year
            let sentThisMonth = dateMonth == currentDate.toString().month
            let sentToday = dateDay == currentDate.toString().day
            
            if !sentThisYear {
                dateLabel.text = "\(dateMonth) \(dateYear)"
            } else {
                dateLabel.text = (!sentThisMonth || !sentToday) ? "\(dateMonth) \(dateDay)" : dateTime
            }
            
            if channel.isUnseenBySupport {
                lastMessagePreviewLabel.textColor = UIColor.white
                let font = lastMessagePreviewLabel.font!
                lastMessagePreviewLabel.font = UIFont.boldSystemFont(ofSize: font.pointSize)
            }
        }
    }
    
}
