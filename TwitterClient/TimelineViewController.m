//
//  TimelineViewController.m
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import "TimelineViewController.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;

@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithData:(id)data {
    self = [super init];
    if(self) {
        self.timelineData = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// table view functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.timelineData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TimelineCell";
    
    TimelineCell *cell = [self.timelineTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimelineCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.tweet = [self.timelineData objectAtIndex:indexPath.row];
    return [cell updateViews];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // open restaurant detail view
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end
