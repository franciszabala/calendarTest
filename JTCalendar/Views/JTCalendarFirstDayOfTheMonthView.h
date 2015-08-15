//
//  JTCalendarFirstDayOfTheMonthView.h
//  CalendarTest
//
//  Created by Francis Zabala on 8/14/15.
//  Copyright (c) 2015 Francis Zabala. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "JTCalendarDay.h"
#import "JTCalendarManager.h"

@interface JTCalendarFirstDayOfTheMonthView : UIView<JTCalendarDay>

@property (nonatomic, weak) JTCalendarManager *manager;

@property (nonatomic) NSDate *date;

@property (nonatomic, readonly) UIView *circleView;
@property (nonatomic, readonly) UIView *dotView;
@property (nonatomic, readonly) UILabel *textLabel;


@property (nonatomic, readonly) UIView *firstMonthDayView;
@property (nonatomic, readonly) UILabel *firstMonthDay;
@property (nonatomic, readonly) UILabel *monthLabel;

@property (nonatomic) CGFloat circleRatio;
@property (nonatomic) CGFloat dotRatio;

@property (nonatomic) BOOL isFirstDayOfTheMonth;

@property (nonatomic) BOOL isFromAnotherMonth;

/*!
 * Must be call if override the class
 */
- (void)commonInit;
@end