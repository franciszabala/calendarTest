//
//  CalendarTest.h
//  CalendarTest
//
//  Created by Francis Zabala on 8/1/15.
//  Copyright (c) 2015 Francis Zabala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@interface CalendarTest : UIViewController<UITableViewDataSource, UITableViewDelegate, JTCalendarDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@end


