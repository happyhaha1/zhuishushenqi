//
//  QSAPI.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/29.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

public protocol TargetType {
    var baseURLString:String { get }
    var path:String { get }
    var parameters:[String:Any]? { get }
}

enum BaseType {
    case normal
    case chapter
}

enum QSAPI {
    ///追书书架信息
    case shelfMSG()
    ///书架更新信息
    case update(id:String)
    ///热门搜索
    case hotwords()
    ///联想搜索
    case autoComplete(query:String)
    ///搜索书籍
    case searchBook(id:String,start:String,limit:String)
    ///排行榜
    case ranking()
    ///榜单数据
    case rankList(id:String)
    ///分类
    case category()
    ///分类详细
    case categoryList(gender:String,type:String,major:String,minor:String,start:String,limit:String)
    ///tag过滤
    case tagType()
    ///主题书单
    case themeTopic(sort:String,duration:String,start:String,gender:String,tag:String)
    ///主题书单详细
    case themeDetail(key:String)
    ///热门评论
    case hotComment(key:String)
    ///普通评论
    case normalComment(key:String,start:String,limit:String)
    ///热门动态
    case hotUser(key:String)
    ///都是热门，忘记干嘛的了
    case hotPost(key:String,start:String,limit:String)
    ///评论详情
    case commentDetail(key:String)
    ///社区
    case community(key:String,start:String)
    ///社区评论
    case communityComment(key:String,start:String)
    ///所有来源
    case allResource(key:String)
    ///所有章节
    case allChapters(key:String)
    ///某一章节
    case chapter(key:String,type:BaseType)
    ///书籍信息
    case book(key:String)
    ///详情页热门评论
    case bookHot(key:String)
    ///详情页可能感兴趣
    case interested(key:String)
    ///详情页推荐书单
    case recommend(key:String)
}

extension QSAPI:TargetType{
    var path: String {
        var pathComponent = ""
        switch self {
        case .shelfMSG():
            pathComponent = "/notification/shelfMessage"
            break
        case .update(_):
            pathComponent = "/book"
            break
        case .hotwords():
            pathComponent = "/book/hot-word"
            break
        case .autoComplete(_):
            pathComponent = "/book/auto-complete"
            break
        case .searchBook(_,_,_):
            pathComponent = "/book/fuzzy-search"
            break
        case .ranking():
            pathComponent = "/ranking/gender"
            break
        case let .rankList(id):
            pathComponent = "/ranking/\(id)"
            break
        case .category():
            pathComponent = "/cats/lv2/statistics"
            break
        case .categoryList(_,_,_,_,_,_):
            pathComponent = "/book/by-categories"
            break
        case .tagType():
            pathComponent = "/book-list/tagType"
            break
        case .themeTopic(_,_,_,_,_):
            pathComponent = "/book-list"
            break
        case let .themeDetail(key):
            pathComponent = "/book-list/\(key)"
            break
        case let .hotComment(key):
            pathComponent = "/post/\(key)/comment/best"
            break
        case let .normalComment(key,_,_):
            pathComponent = "/post/review/\(key)/comment"
            break
        case let .hotUser(key):
            pathComponent = "/user/twitter/\(key)/comments"
            break
        case let .hotPost(key,_,_):
            pathComponent = "/post/\(key)/comment"
            break
        case let .commentDetail(key):
            pathComponent = "/post/review/\(key)"
            break
        case let .community(key,start):
            pathComponent = "/post/by-book?book=\(key)&sort=updated&type=normal,vote&start=\(start)&limit=20"
            break
        case let .communityComment(key, start):
            pathComponent = "/post/review/by-book?book=\(key)&sort=updated&start=\(start)&limit=20"
            break
        case .allResource(_):
            pathComponent = "/mix-atoc"
            break
        case let .allChapters(key):
            pathComponent = "/mix-atoc/\(key)"
            break
        case let .chapter(key,_):
            pathComponent = "/\(key)?k=22870c026d978c75&t=1489933049"
            break
        case let .book(key):
            pathComponent = "/book/\(key)"
            break
        case let .bookHot(key):
            pathComponent = "/post/review/best-by-book?book=\(key)"
            break
        case let .interested(key):
            pathComponent = "/book/\(key)/recommend"
            break
        case let .recommend(key):
            pathComponent = "/book-list/\(key)/recommend?limit=3"
            break
        }
        return "\(baseURLString)\(pathComponent)"
    }

    var baseURLString: String{
        var urlString = "http://api.zhuishushenqi.com"
        switch self {
        case let .chapter(_, type):
            switch type {
            case .chapter:
                urlString = "http://chapter2.zhuishushenqi.com/chapter"
            default:
                urlString = "http://api.zhuishushenqi.com"
            }
        default:
            urlString = "http://api.zhuishushenqi.com"
        }
        return urlString
    }
    
    var parameters: [String : Any]?{
        switch self {
        case let .update(id):
            return ["view":"updated","id":id]
        case let .autoComplete(query):
            return ["query":query]
        case let .searchBook(id,start,limit):
            return ["query":id,"start":start,"limit":limit]
        case .shelfMSG():
            return ["platform":"ios"]
        case let .categoryList(gender,type,major,minor,start,limit):
            return ["gender":gender,"type":type,"major":major,"minor":minor,"start":start,"limit":limit]
        case let .themeTopic(sort,duration,start,gender,tag):
            return ["sort":sort,"duration":duration,"start":start,"gender":gender,"tag":tag]
        case let .normalComment(_,start,limit):
            return ["start":start,"limit":limit]
        case let .hotPost(_,start,limit):
            return ["start":start,"limit":limit]
        case let .allResource(key):
            return ["view":"summary","book":key]
        case .allChapters(_):
            return ["view":"chapters"]
        default:
            return nil
        }
    }
}

