//
//  MenuViewController.h
//  TwitterClient
//
//  Created by Kevin Ku on 7/13/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

#import "TwitterAPI.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) BOOL isShowing;
@property (nonatomic) NSArray *options;
@property (nonatomic) NSDictionary *userData;

@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;

@end
