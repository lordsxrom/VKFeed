//
//  NewsFeedCellLayoutCalculator.swift
//  VKFeed
//
//  Created by Nikita Shumskii on 19.12.2022.
//

import UIKit

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var moreTextButtonFrame: CGRect
    var attachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
}

protocol NewsFeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachements: [FeedCellPhotoAttachementViewModel], isFullSized: Bool) -> FeedCellSizes
}

final class NewsFeedCellLayoutCalculator: NewsFeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachements: [FeedCellPhotoAttachementViewModel], isFullSized: Bool) -> FeedCellSizes {
        var showMoreTextButton = false
        
        let cardViewWidth = screenWidth - Constants.cardIndest.left - Constants.cardIndest.right
        
        var postLabelFrame = CGRect(
            origin: CGPoint(x: Constants.postLabelIndest.left, y: Constants.postLabelIndest.top),
            size: CGSize.zero
        )
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.postLabelIndest.left - Constants.postLabelIndest.right
            var heigth = text.height(width: width, font: Constants.postLabelFont)
            
            let limitHeigth = Constants.postLabelFont.lineHeight * Constants.minifiedPostLimitLines
            if !isFullSized && heigth > limitHeigth {
                heigth = Constants.postLabelFont.lineHeight * Constants.minifiedPostLines
                showMoreTextButton = true
            }
            
            postLabelFrame.size = CGSize(width: width, height: heigth)
        }
        
        var moreTextButtonSize = CGSize.zero
        if showMoreTextButton {
            moreTextButtonSize = Constants.moreTextButtonSize
        }
        let moreTextButtonOrigin = CGPoint(x: Constants.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelIndest.top : moreTextButtonFrame.maxY + Constants.postLabelIndest.bottom
        var attachmentFrame = CGRect(
            origin: CGPoint(x: 0, y: attachmentTop),
            size: CGSize.zero
        )
        
        if let attachment = photoAttachements.first {
            let ratio = CGFloat(Float(attachment.height) / Float(attachment.width))
            if photoAttachements.count == 1 {
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
            } else if photoAttachements.count > 1 {
                let photos = photoAttachements.map { (photo) -> CGSize in
                    CGSize(width: photo.width, height: photo.height)
                }
                let rowHeight = RowLayout.rowHeightCounter(superviewWidth: cardViewWidth, photosArray: photos)
                attachmentFrame.size = CGSize(width: cardViewWidth, height: rowHeight!)
            }
        }
        
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        var bottomViewFrame = CGRect(
            origin: CGPoint(x: 0, y: bottomViewTop),
            size: CGSize(width: cardViewWidth, height: Constants.bottonViewHeigth)
        )
        
        let totalHeight = bottomViewFrame.maxY + Constants.cardIndest.bottom
        
        return Sizes(
            postLabelFrame: postLabelFrame,
            moreTextButtonFrame: moreTextButtonFrame,
            attachmentFrame: attachmentFrame,
            bottomViewFrame: bottomViewFrame,
            totalHeight: totalHeight
        )
    }
    
}
