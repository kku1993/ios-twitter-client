//
//  MentionsViewController.m
//  TwitterClient
//
//  Created by Kevin Ku on 7/14/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import "MentionsViewController.h"

@interface MentionsViewController ()

@end

@implementation MentionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mentionsTableView.delegate = self;
    self.mentionsTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getUserMentions{
    [[TwitterAPI instance] getMentionsTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.mentions = responseObject;
        
        void (^updateUI)(void) = ^{
            // make sure error box is not showing
            [self.mentionsTableView reloadData];
        };
        
        // update table view
        if([NSThread isMainThread]) {
            updateUI();
        }
        else {
            dispatch_sync(dispatch_get_main_queue(), updateUI);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failde to get user's tweets. Error:%@", error);
    }];
}


// table view functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.mentions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MentionCell";
    
    TimelineCell *cell = [self.mentionsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimelineCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.tweet = [self.mentions objectAtIndex:indexPath.row];
    return [cell updateViews];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // open tweet detail view
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    TweetViewController *tvc = [[TweetViewController alloc] initWithTweet:[self.mentions objectAtIndex:indexPath.row]];
    [tvc setTitle:@"Tweet"];
    
    [self.navigationController pushViewController:tvc animated:true];
}


@end
