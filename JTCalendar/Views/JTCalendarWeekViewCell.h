//
//  JTCalendarWeekViewCell.h
//  CalendarTest
//
//  Created by Francis Zabala on 8/25/15.
//  Copyright (c) 2015 Francis Zabala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendarWeek.h"

@interface JTCalendarWeekViewCell : UIView<JTCalendarWeek>

@property (nonatomic, weak) JTCalendarManager *manager;

@property (nonatomic, readonly) NSDate *startDate;

/*!
 * Must be call if override the class
 */
- (void)commonInit;
@end