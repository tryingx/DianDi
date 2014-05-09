//
//  newsCell.h
//  DianDi
//
//  Created by ㊣Trying-X™ on 13-12-3.
//  Copyright (c) 2013年 Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newsCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *news_redu;
@property (nonatomic, retain) IBOutlet UIImageView *news_image;
@property (nonatomic, retain) IBOutlet UILabel *news_title;
@property (nonatomic, retain) IBOutlet UILabel *news_info;
@property (retain, nonatomic) IBOutlet UILabel *news_time;
@end
