//
//  NewsInfo.h
//  DianDi
//
//  Created by ㊣Trying-X™ on 13-12-11.
//  Copyright (c) 2013年 Gavin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *newsUrl;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *publishDate;
@property (nonatomic, copy) NSString *lastUpdateTime;
@end
