//
//  TimelineViewController.h
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMProgressHUD/MMProgressHUD.h>

#import "TimelineCell.h"
#import "TwitterAPI.h"

@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *timelineData;

- (id)initWithData:(id)data;

@end
