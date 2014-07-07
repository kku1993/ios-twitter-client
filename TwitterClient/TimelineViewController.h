//
//  TimelineViewController.h
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineViewController : UIViewController

@property (nonatomic) NSDictionary *timelineData;

- (id)initWithData:(id)data;

@end
