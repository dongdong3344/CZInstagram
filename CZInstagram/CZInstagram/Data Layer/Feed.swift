//
//  Feed.swift
//  CZInstagram
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit
import EasyMapping

class Feed: CZModel {
    lazy var feedId: String = ""
    var type: String?           // “image”, “video”, “carousel”
    var user: User?
    var userHasLiked: Bool {
        return _userHasLiked?.boolValue ?? false
    }
    var _userHasLiked: NSNumber?
    var content: String?
    var imageInfo: ImageInfo?
    var createTime: String?     // “create_time”: “1279340983”
    var commentsCount: Int? {return _commentsCount?.intValue}
    var likesCount: Int? {return _likesCount?.intValue}
    var _commentsCount: NSNumber?
    var _likesCount: NSNumber?

    override init() { super.init() }
    required init(dictionary: CZDictionary) {
        super.init(dictionary: dictionary)        
    }

    override class func objectMapping() -> EKObjectMapping {
        let allMapping = super.objectMapping()
        let mapping = EKObjectMapping(objectClass: self)
        mapping.mapProperties(from: ["id": "feedId",
                                     "type": "type",
                                     "caption.text": "content",
                                     "createTime": "createTime",
                                     "user_has_liked": "_userHasLiked",
                                     "comments.count": "_commentsCount",
                                     "likes.count": "_likesCount",
                                     ])
        mapping.hasOne(User.self, forKeyPath: "user", forProperty: "user")
        mapping.hasOne(ImageInfo.self, forKeyPath: "images.standard_resolution", forProperty: "imageInfo")
        allMapping.mapProperties(fromMappingObject: mapping)
        return allMapping
    }
}

extension Feed: State {
    func react(to event: Event) {
        switch event {
        case let CZFeedListViewEvent.selectedCell(feedModel): // Update liked locally
            if let viewModel = feedModel.viewModel as? FeedCellViewModel,
                viewModel.feed.feedId == feedId {
                _userHasLiked = NSNumber(value: !_userHasLiked!.boolValue)
            }
        default:
            break
        }
    }
    
}
