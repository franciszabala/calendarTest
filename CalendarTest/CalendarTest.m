//
//  CalendarTest.m
//  CalendarTest
//
//  Created by Francis Zabala on 8/1/15.
//  Copyright (c) 2015 Francis Zabala. All rights reserved.
//

#import "CalendarTest.h"

@implementation CalendarTest
{
    UIView *top;
    UIView *bottom;
    UITableView *topTableView;
    UITableView *bottomTableView;
    NSArray *tableViewItems;
    CGRect topFrameOpened;
    CGRect bottomFrameClosed;
    CGRect topFrameClosed;
    CGRect bottomFrameOpened;
    BOOL isTopOpen;
    
    JTCalendarMenuView *calendarMenuView;
    JTVerticalCalendarView *calendarContentView;
    JTCalendarWeekDayView *weekDayView;
    
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
}

@synthesize calendarManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    
    
//    self.theTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewWhateverStyleYouWantHere];
//    theTableView.dataSource = self, theTableView.delegate = self;
//    [self.view addSubview:theTableView];
    
    self.title = @"Basic";
    CGFloat origY =65.0f+40.0f;
    
    CGFloat origBottom =origY + 150.0f;
    
    topFrameOpened = CGRectMake(0.0f, origY, 320.0f, 220.0f);
    bottomFrameClosed = CGRectMake(0.0f, origBottom + 65.0f+40, 320.0f, 80.0f);
    
    topFrameClosed = CGRectMake(0.0f, origY, 320.0f, 100.0f);
    bottomFrameOpened = CGRectMake(0.0f, origBottom-80.0f, 320.0f, 150.0f);
    isTopOpen = true;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTableViewItems];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    
    top = [UIView new];
    top.backgroundColor = [UIColor blueColor];
    
    bottom = [UIView new];
    bottom.backgroundColor = [UIColor greenColor];
    
    
    top.frame = topFrameOpened;
    bottom.frame = bottomFrameClosed;
    
    topTableView = [[UITableView alloc] initWithFrame:topFrameOpened style:UITableViewStylePlain];
    bottomTableView = [[UITableView alloc] initWithFrame:bottomFrameClosed style:UITableViewStylePlain];
    topTableView.backgroundColor = [UIColor blueColor];
    bottomTableView.backgroundColor = [UIColor greenColor];

    topTableView.tag = 69;
    bottomTableView.tag = 42;
    
    topTableView.delegate = self;
    topTableView.dataSource = self;
    
    bottomTableView.delegate = self;
    bottomTableView.dataSource = self;
    
    bottomTableView.backgroundColor = [UIColor cyanColor];
    
    /*
    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    
    
    calendarMenuView = [JTCalendarMenuView new];
    calendarContentView = [JTHorizontalCalendarView new];
    calendarContentView.delegate = self;
    calendarContentView.backgroundColor = [UIColor yellowColor];
    calendarContentView.tag = 69;
    
    calendarContentView.frame = topFrameOpened;
    
    [calendarManager setMenuView:calendarMenuView];
    [calendarManager setContentView:calendarContentView];
    [calendarManager setDate:_todayDate];
    
    [self.view addSubview:calendarContentView];
    [self.view addSubview:bottomTableView];
    */
    
    
    calendarMenuView = [JTCalendarMenuView new];
    calendarMenuView.frame = CGRectMake(0.0f, 65.0f, 320.0f, 40.0f);
    
    weekDayView = [JTCalendarWeekDayView new];
    weekDayView.frame = CGRectMake(0.0f, 65.0f, 320.0f, 20.0f);
    
    calendarContentView = [JTVerticalCalendarView new];
    calendarContentView.delegate = self;
    calendarContentView.backgroundColor = [UIColor yellowColor];
    calendarContentView.tag = 69;
   
    
    calendarContentView.frame = topFrameOpened;

    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    

    calendarManager.settings.pageViewHaveWeekDaysView = NO;
    calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    calendarManager.settings.isResizeAutomatic = NO;
    
    weekDayView.manager = calendarManager;
    //[weekDayView reload];
    
    // Generate random events sort by date using a dateformatter for the demonstration
    //[self createRandomEvents];
    
    [calendarManager setMenuView:calendarMenuView];
    [calendarManager setContentView:calendarContentView];
    [calendarManager setDate:[NSDate date]];
    //calendarMenuView.scrollView.scrollEnabled = NO;
    calendarMenuView.scrollView.scrollEnabled = NO;
    calendarMenuView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:calendarMenuView];
    [self.view addSubview:calendarContentView];
    [self.view addSubview:bottomTableView];
    //[self.view addSubview:weekDayView];

}


#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [tableViewItems count];
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellTopIdentifier = @"HistoryCell";
    static NSString *cellIdentifier = @"HistoryCell";
    if (theTableView.tag == 42) {
    

    
  
        
        
        UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTopIdentifier];
        }
        // Just want to test, so I hardcode the data
        int count = [tableViewItems count] - 1;
        cell.textLabel.text = [tableViewItems objectAtIndex:count - indexPath.row];
        
        return cell;

    } else {
        // Similar to UITableViewCell, but
        UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        // Just want to test, so I hardcode the data
        cell.textLabel.text = [tableViewItems objectAtIndex:indexPath.row];
        
        return cell;
            }
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //NSLog(@"%i", scrollView.tag);
    
    //check if top is minimized

    
    if (scrollView.tag == 42 && isTopOpen) {
        //calendarManager.settings.isResizeAutomatic = NO;
        [UIView animateWithDuration:0.3
                              delay: 0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             calendarContentView.frame = topFrameClosed;
                             bottomTableView.frame = bottomFrameOpened;
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                             isTopOpen = false;
                             //calendarContentView.contentSize = CGSizeMake(320.0f, 50.0f);
                             
//                             topFrameOpened = CGRectMake(0.0f, 65.0f, 320.0f, 250.0f);
//                             bottomFrameClosed = CGRectMake(0.0f, 250.0f + 65.0f, 320.0f, 50.0f);
//                             
//                             topFrameClosed = CGRectMake(0.0f, 65.0f, 320.0f, 50.0f);
//                             bottomFrameOpened = CGRectMake(0.0f, 50.0f + 65.0f, 320.0f, 150.0f);
                             //calendarManager.settings.pageViewNumberOfWeeks = 2;
                             //calendarManager.settings.weekModeEnabled = !calendarManager.settings.weekModeEnabled;
                             //[calendarManager reload];
                             
                             
                         }];

        
    } else if (scrollView.tag == 69 && !isTopOpen) {
        //calendarManager.settings.isResizeAutomatic = YES;
        [UIView animateWithDuration:0.3
                              delay: 0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             calendarContentView.frame = topFrameOpened;
                             bottomTableView.frame = bottomFrameClosed;
                         }
                         completion:^(BOOL finished){
                             //NSLog(@"Done!");
                             isTopOpen = true;
                             //calendarContentView.contentSize = CGSizeMake(320.0f, 250.0f);

                         //NSLog(@" calendarContentView.contentSize  %@",  calendarContentView.contentSize );
                             //calendarManager.settings.pageViewNumberOfWeeks = 0;
                             //calendarManager.settings.weekModeEnabled = !calendarManager.settings.weekModeEnabled;
                             //[calendarManager reload];
                         }];
    
    }
    
}


#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
//- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"selected %d row", indexPath.row);
//    
//    if (theTableView.tag == 42 && isTopOpen) {
//        calendarManager.settings.isResizeAutomatic = NO;
//        
//        [UIView animateWithDuration:0.3
//                              delay: 0.0
//                            options: UIViewAnimationOptionCurveLinear
//                         animations:^{
//                             calendarContentView.frame = topFrameClosed;
//                             bottomTableView.frame = bottomFrameOpened;
//                         }
//                         completion:^(BOOL finished){
//                             NSLog(@"Done!");
//                             isTopOpen = false;
//                         }];
//        
//        
//    } else if (theTableView.tag == 69 && !isTopOpen) {
//        calendarManager.settings.isResizeAutomatic = YES;
//        [UIView animateWithDuration:0.3
//                              delay: 0.0
//                            options: UIViewAnimationOptionCurveLinear
//                         animations:^{
//                             calendarContentView.frame = topFrameOpened;
//                             bottomTableView.frame = bottomFrameClosed;
//                         }
//                         completion:^(BOOL finished){
//                             NSLog(@"Done!");
//                             isTopOpen = true;
//                         }];
//        
//    }
//
//    
//}




- (void) createTableViewItems {
    tableViewItems = [NSArray new];
    tableViewItems = @[@"Mercedes-Benz", @"BMW", @"Porsche",
                       @"Opel", @"Volkswagen", @"Audi"];
}


#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
//    if([self haveEventForDay:dayView.date]){
//        dayView.dotView.hidden = NO;
//    }
//    else{
//        dayView.dotView.hidden = YES;
//    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [calendarContentView loadNextPageWithAnimation];
        }
        else{
            [calendarContentView loadPreviousPageWithAnimation];
        }
    }
}
//
//#pragma mark - CalendarManager delegate - Page mangement
//
//// Used to limit the date for the calendar, optional
//- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
//{
//    return [calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
//}
//
//- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
//{
//    //    NSLog(@"Next page loaded");
//}
//
//- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
//{
//    //    NSLog(@"Previous page loaded");
//}
//
//#pragma mark - Fake data
//
//- (void)createMinAndMaxDate
//{
//    _todayDate = [NSDate date];
//    
//    // Min date will be 2 month before today
//    _minDate = [calendarManager.dateHelper addToDate:_todayDate months:-2];
//    
//    // Max date will be 2 month after today
//    _maxDate = [calendarManager.dateHelper addToDate:_todayDate months:2];
//}
//
//// Used only to have a key for _eventsByDate
//- (NSDateFormatter *)dateFormatter
//{
//    static NSDateFormatter *dateFormatter;
//    if(!dateFormatter){
//        dateFormatter = [NSDateFormatter new];
//        dateFormatter.dateFormat = @"dd-MM-yyyy";
//    }
//    
//    return dateFormatter;
//}
//
//- (BOOL)haveEventForDay:(NSDate *)date
//{
//    NSString *key = [[self dateFormatter] stringFromDate:date];
//    
//    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
//        return YES;
//    }
//    
//    return NO;
//    
//}
//
//- (void)createRandomEvents
//{
//    _eventsByDate = [NSMutableDictionary new];
//    
//    for(int i = 0; i < 30; ++i){
//        // Generate 30 random dates between now and 60 days later
//        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
//        
//        // Use the date as key for eventsByDate
//        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
//        
//        if(!_eventsByDate[key]){
//            _eventsByDate[key] = [NSMutableArray new];
//        }
//        
//        [_eventsByDate[key] addObject:randomDate];
//    }
//}

//Exemple of implementation of prepareDayView method
//Used to customize the appearance of dayView
//- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
//{
//    // Other month
//    if([dayView isFromAnotherMonth]){
//        dayView.hidden = YES;
//    }
//    // Today
//    else if([calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
//        dayView.circleView.hidden = NO;
//        dayView.circleView.backgroundColor = [UIColor blueColor];
//        dayView.dotView.backgroundColor = [UIColor whiteColor];
//        dayView.textLabel.textColor = [UIColor whiteColor];
//    }
//    // Selected date
//    else if(_dateSelected && [calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
//        dayView.circleView.hidden = NO;
//        dayView.circleView.backgroundColor = [UIColor redColor];
//        dayView.dotView.backgroundColor = [UIColor whiteColor];
//        dayView.textLabel.textColor = [UIColor whiteColor];
//    }
//    // Other month
//    else if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
//        dayView.circleView.hidden = YES;
//        dayView.dotView.backgroundColor = [UIColor redColor];
//        dayView.textLabel.textColor = [UIColor lightGrayColor];
//    }
//    // Another day of the current month
//    else{
//        dayView.circleView.hidden = YES;
//        dayView.dotView.backgroundColor = [UIColor redColor];
//        dayView.textLabel.textColor = [UIColor blackColor];
//    }
//    
//    if([self haveEventForDay:dayView.date]){
//        dayView.dotView.hidden = NO;
//    }
//    else{
//        dayView.dotView.hidden = YES;
//    }
//}
//
//- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
//{
//    _dateSelected = dayView.date;
//    
//    // Animation for the circleView
//    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
//    [UIView transitionWithView:dayView
//                      duration:.3
//                       options:0
//                    animations:^{
//                        dayView.circleView.transform = CGAffineTransformIdentity;
//                        [calendarManager reload];
//                    } completion:nil];
//    
//    
//    // Load the previous or next page if touch a day from another month
//    
//    if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
//        if([calendarContentView.date compare:dayView.date] == NSOrderedAscending){
//            [calendarContentView loadNextPageWithAnimation];
//        }
//        else{
//            [calendarContentView loadPreviousPageWithAnimation];
//        }
//    }
//}
//
//#pragma mark - Fake data
//
//// Used only to have a key for _eventsByDate
//- (NSDateFormatter *)dateFormatter
//{
//    static NSDateFormatter *dateFormatter;
//    if(!dateFormatter){
//        dateFormatter = [NSDateFormatter new];
//        dateFormatter.dateFormat = @"dd-MM-yyyy";
//    }
//    
//    return dateFormatter;
//}
//
//- (BOOL)haveEventForDay:(NSDate *)date
//{
//    NSString *key = [[self dateFormatter] stringFromDate:date];
//    
//    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
//        return YES;
//    }
//    
//    return NO;
//    
//}
//
//- (void)createRandomEvents
//{
//    _eventsByDate = [NSMutableDictionary new];
//    
//    for(int i = 0; i < 30; ++i){
//        // Generate 30 random dates between now and 60 days later
//        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
//        
//        // Use the date as key for eventsByDate
//        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
//        
//        if(!_eventsByDate[key]){
//            _eventsByDate[key] = [NSMutableArray new];
//        }
//        
//        [_eventsByDate[key] addObject:randomDate];
//    }
//}


@end
