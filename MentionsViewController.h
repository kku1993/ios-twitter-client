//
//  MentionsViewController.h
//  TwitterClient
//
//  Created by Kevin Ku on 7/14/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TimelineCell.h"
#import "TweetViewController.h"

@interface MentionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mentionsTableView;

@property (nonatomic) NSArray *mentions;

@end
