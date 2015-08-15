//
//  JTWeekViewCell.h
//  CalendarTest
//
//  Created by Francis Zabala on 8/14/15.
//  Copyright (c) 2015 Francis Zabala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendarWeek.h"

@interface JTWeekViewCell : UITableViewCell

@property (strong,nonatomic) UIView<JTCalendarWeek> *weekView;
@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) UIView *derp;

@end
