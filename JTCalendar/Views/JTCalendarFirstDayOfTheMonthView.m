//
//  JTCalendarFirstDayOfTheMonthView.m
//  CalendarTest
//
//  Created by Francis Zabala on 8/14/15.
//  Copyright (c) 2015 Francis Zabala. All rights reserved.
//

#import "JTCalendarFirstDayOfTheMonthView.h"

@implementation JTCalendarFirstDayOfTheMonthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.clipsToBounds = YES;
    
    _circleRatio = .9;
    _dotRatio = 1. / 9.;
    
    {
        _circleView = [UIView new];
        [self addSubview:_circleView];
        
        _circleView.backgroundColor = [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5];
        _circleView.hidden = YES;
    }
    
    {
        _dotView = [UIView new];
        [self addSubview:_dotView];
        
        _dotView.backgroundColor = [UIColor redColor];
        _dotView.hidden = YES;
    }
    
    {
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
        
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    {
        _firstMonthDayView = [UIView new];
        [self addSubview:_firstMonthDayView];
        _firstMonthDayView.hidden = YES;
        _firstMonthDayView.backgroundColor = [UIColor whiteColor];

    }
    
    {
        _monthLabel = [UILabel new];
        [self.firstMonthDayView addSubview:_monthLabel];
        
        _monthLabel.textColor = [UIColor redColor];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    
    {
        _firstMonthDay = [UILabel new];
        [self.firstMonthDayView addSubview:_firstMonthDay];
        
        _firstMonthDay.textColor = [UIColor redColor];
        _firstMonthDay.textAlignment = NSTextAlignmentCenter;
        _firstMonthDay.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
}

- (void)layoutSubviews
{
    
//    NSLog(@"self.bounds: %@", NSStringFromCGRect(self.bounds));
//    NSLog(@"monthLabel.text.length: %i",_monthLabel.text.length);
//    
//        if (self.isFirstDayOfTheMonth) {
//        CGRect _textLabelFrame = self.bounds;
//        _textLabelFrame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y+5.0f, self.bounds.size.width, self.bounds.size.height);
//        _textLabel.frame = _textLabelFrame;
//        _textLabel.textColor = [UIColor redColor];
//        
//        CGRect _monthLabelFrame = _textLabelFrame;
//        _monthLabelFrame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y-9.0f, self.bounds.size.width, self.bounds.size.height);
//        
//        
//        _monthLabel.frame = _monthLabelFrame;
//    } else {
    
    _textLabel.frame = self.bounds;
    _firstMonthDayView.frame = self.bounds;
    //_monthLabel.frame = _firstMonthDayView.frame;
    //_firstMonthDay.frame = _firstMonthDayView.frame;
    
    _monthLabel.frame = CGRectMake(_firstMonthDayView.bounds.origin.x, _firstMonthDayView.bounds.origin.y-9.0f, _firstMonthDayView.bounds.size.width, _firstMonthDayView.bounds.size.height);
        
    _firstMonthDay.frame = CGRectMake(_firstMonthDayView.bounds.origin.x, _firstMonthDayView.bounds.origin.y+5.0f, _firstMonthDayView.bounds.size.width, _firstMonthDayView.bounds.size.height);

    
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * _circleRatio;
    sizeDot = sizeDot * _dotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    _circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    _circleView.layer.cornerRadius = sizeCircle / 2.;
    
    _dotView.frame = CGRectMake(0, 0, sizeDot, sizeDot);
    _dotView.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) +sizeDot * 2.5);
    _dotView.layer.cornerRadius = sizeDot / 2.;
    
}

- (void)setDate:(NSDate *)date
{
    NSAssert(date != nil, @"date cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    self->_date = date;
    [self reload];
}

- (void)reload
{
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [_manager.dateHelper createDateFormatter];
        [dateFormatter setDateFormat:@"d"];
    }

    _textLabel.text = [dateFormatter stringFromDate:_date];
    _firstMonthDay.text = [dateFormatter stringFromDate:_date];

    static NSDateFormatter *monthFormatter = nil;
    if(!monthFormatter){
        monthFormatter = [_manager.dateHelper createDateFormatter];
        [monthFormatter setDateFormat:@"MMM"];
    }

    _monthLabel.text = [monthFormatter stringFromDate:_date];
    //_textLabel.text = [NSString stringWithFormat:@"%@  %@", [dateFormatter stringFromDate:_date], @"derp"];
    [_manager.delegateManager prepareDayView:self];
    
}

- (void)didTouch
{
    [_manager.delegateManager didTouchDayView:self];
}


@end
