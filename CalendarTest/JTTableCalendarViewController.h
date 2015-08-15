//
//  JTTableCalendarViewController.h
//  CalendarTest
//
//  Created by Francis Zabala on 8/13/15.
//  Copyright (c) 2015 Francis Zabala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@interface JTTableCalendarViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, JTCalendarDelegate, UIScrollViewDelegate>


@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (strong, nonatomic) UITableView *tableView;
@end
