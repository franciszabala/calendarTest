//
//  JTTableCalendarViewController.m
//  CalendarTest
//
//  Created by Francis Zabala on 8/13/15.
//  Copyright (c) 2015 Francis Zabala. All rights reserved.
//

#import "JTTableCalendarViewController.h"
#import "JTCalendarWeek.h"

@interface JTTableCalendarViewController () {
    NSArray *tableViewItems;
    NSMutableArray *pastDates;
    NSMutableArray *futureDates;
    NSDateComponents *dayComponent;
    NSCalendar *theCalendar;
    NSDate *fixedPointDate;
    
    NSDate *movingPointDate;
    
    NSMutableArray *combinationDates;
    
    UITableView *tableView;
    
    CGRect topFrameOpened;
    CGRect topFrameClosed;
}
@end


@implementation JTTableCalendarViewController
@synthesize calendarManager;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat origY =65.0f+40.0f;
    //CGFloat origBottom =origY + 150.0f;
    topFrameOpened = CGRectMake(0.0f, origY, 320.0f, 220.0f);
    topFrameClosed = CGRectMake(0.0f, origY, 320.0f, 100.0f);
    self.automaticallyAdjustsScrollViewInsets = NO;
    tableView = [[UITableView alloc] initWithFrame:topFrameOpened style:UITableViewStylePlain];
    
    fixedPointDate = [NSDate date];
    dayComponent = [[NSDateComponents alloc] init];
    theCalendar = [NSCalendar currentCalendar];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    //[self createTableViewItems];
    
    
    
    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    [calendarManager setDate:fixedPointDate];
    
    [self createFutureDatesWithReferencePoint:[calendarManager.dateHelper firstWeekDayOfWeek:fixedPointDate]];
    [self createPastDatesWithReferencePoint:[calendarManager.dateHelper firstWeekDayOfWeek:fixedPointDate]];
    
    
    combinationDates = [NSMutableArray new];
    [combinationDates addObjectsFromArray:pastDates];
    [combinationDates addObjectsFromArray:futureDates];
    
    tableView.frame = CGRectMake(0.0f, 85.0f, 220.0f, 80.0f);
    NSLog(@"%@", NSStringFromCGRect(tableView.frame));
    tableView.tag = 6090;
    [self.view addSubview:tableView];
    //tableView.hidden = YES;
    
    //
    //self.automaticallyAdjustsScrollViewInsets = NO;
    //
    //
    //
    //    top = [UIView new];
    //    top.backgroundColor = [UIColor blueColor];
    //
    //    bottom = [UIView new];
    //    bottom.backgroundColor = [UIColor greenColor];
    //
    //
    //    top.frame = topFrameOpened;
    //    bottom.frame = bottomFrameClosed;
    //
    //    topTableView = [[UITableView alloc] initWithFrame:topFrameOpened style:UITableViewStylePlain];
    //    bottomTableView = [[UITableView alloc] initWithFrame:bottomFrameClosed style:UITableViewStylePlain];
    //    topTableView.backgroundColor = [UIColor blueColor];
    //    bottomTableView.backgroundColor = [UIColor greenColor];
    //
    //    topTableView.tag = 69;
    //    bottomTableView.tag = 42;
    //
    //    topTableView.delegate = self;
    //    topTableView.dataSource = self;
    //
    //    bottomTableView.delegate = self;
    //    bottomTableView.dataSource = self;
    //
    //    bottomTableView.backgroundColor = [UIColor cyanColor];
    
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
    
    
    //    calendarMenuView = [JTCalendarMenuView new];
    //    calendarMenuView.frame = CGRectMake(0.0f, 65.0f, 320.0f, 40.0f);
    //
    //    weekDayView = [JTCalendarWeekDayView new];
    //    weekDayView.frame = CGRectMake(0.0f, 65.0f, 320.0f, 20.0f);
    //
    //    calendarContentView = [JTVerticalCalendarView new];
    //    calendarContentView.delegate = self;
    //    calendarContentView.backgroundColor = [UIColor yellowColor];
    //    calendarContentView.tag = 69;
    //
    //
    //    calendarContentView.frame = topFrameOpened;
    //
    //    calendarManager = [JTCalendarManager new];
    //    calendarManager.delegate = self;
    //
    //
    //    calendarManager.settings.pageViewHaveWeekDaysView = NO;
    //    calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    //    calendarManager.settings.isResizeAutomatic = NO;
    //
    //    weekDayView.manager = calendarManager;
    //[weekDayView reload];
    
    // Generate random events sort by date using a dateformatter for the demonstration
    //[self createRandomEvents];
    
    //    [calendarManager setMenuView:calendarMenuView];
    //    [calendarManager setContentView:calendarContentView];
    //    [calendarManager setDate:[NSDate date]];
    //    //calendarMenuView.scrollView.scrollEnabled = NO;
    //    calendarMenuView.scrollView.scrollEnabled = NO;
    //    calendarMenuView.backgroundColor = [UIColor redColor];
    //
    //    [self.view addSubview:calendarMenuView];
    //    [self.view addSubview:calendarContentView];
    //    [self.view addSubview:bottomTableView];
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
    //return [futureDates count];
    
    return [combinationDates count]; //roughly 52 weeks in a year
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"theTableView.tag: %d", theTableView.tag);
    //static NSString *cellTopIdentifier = @"HistoryCell";
    static NSString *cellIdentifier = @"Derp";
    //    if (theTableView.tag == 42) {
    //
    //        UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //        if (cell == nil) {
    //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTopIdentifier];
    //        }
    //        // Just want to test, so I hardcode the data
    //        int count = [tableViewItems count] - 1;
    //        cell.textLabel.text = [tableViewItems objectAtIndex:count - indexPath.row];
    //
    //        return cell;
    //
    //    } else {
    // Similar to UITableViewCell, but
    
    
    
    
    UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UIView<JTCalendarWeek> *weekView;
    if ([cell viewWithTag:6526] == nil) {
        weekView = [calendarManager.delegateManager buildWeekView];
        [weekView setManager:calendarManager];
        weekView.tag = 6526;
        weekView.backgroundColor = [UIColor blueColor];
        weekView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
        [weekView setStartDate:[combinationDates objectAtIndex:indexPath.row] updateAnotherMonth:NO monthDate:fixedPointDate];
        [cell.contentView addSubview:weekView];
        //NSLog(@"creating new weekview");
    } else {
        weekView = (UIView<JTCalendarWeek>*)[cell viewWithTag:6526];
        [weekView setStartDate:[combinationDates objectAtIndex:indexPath.row] updateAnotherMonth:NO monthDate:fixedPointDate];
        //NSLog(@"old weekview");
    }
    
    
    //    NSDate* weekDate = [calendarManager.dateHelper firstWeekDayOfWeek:[NSDate date]];
    //
    //    UIView<JTCalendarWeek> *weekView = (UIView<JTCalendarWeek>*) [cell viewWithTag:6526];
    //
    //
    //        weekView = [calendarManager.delegateManager buildWeekView];
    //        [weekView setManager:calendarManager];
    //        weekView.tag = 6526;
    //        weekView.backgroundColor = [UIColor blueColor];
    //        weekView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
    //
    //
    //
    //    dayComponent.day = indexPath.row*7;
    //    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:weekDate options:0];
    //    //weekDate = [_manager.dateHelper firstWeekDayOfMonth:_date];
    //
    //    [weekView setStartDate:nextDate updateAnotherMonth:NO monthDate:[NSDate date]];
    //
    //if (weekView != nil) {
    //
    // } else {
    //    [cell.contentView addSubview:weekView];
    // }
    
    
    //weekView.manager = calendarManager;
    //}
    //    dayComponent.day = indexPath.row;
    //    NSDate *dateMe = [theCalendar dateByAddingComponents:dayComponent toDate: [NSDate date] options:0];
    //
    //    cell.textLabel.text = [NSDateFormatter localizedStringFromDate:dateMe
    //                                                               dateStyle:NSDateFormatterShortStyle
    //                                                               timeStyle:NSDateFormatterShortStyle];
    
    //    NSDate *dateIndex = [combinationDates objectAtIndex:indexPath.row];
    //        cell.textLabel.text = [NSDateFormatter localizedStringFromDate:dateIndex
    //                                                                   dateStyle:NSDateFormatterShortStyle
    //                                                                   timeStyle:NSDateFormatterShortStyle];
    
    return cell;
    // }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) createTableViewItems {
    tableViewItems = [NSArray new];
    tableViewItems = @[@"Mercedes-Benz", @"BMW", @"Porsche",
                       @"Opel", @"Volkswagen", @"Audi"];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) createFutureDates {
    futureDates = [NSMutableArray new];
    
    
    for (int i = 0; i < 52; i++) {
        
        //dayComponent.day = (i+1)*7;
        dayComponent.day = i;
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:fixedPointDate options:0];
        [futureDates addObject:nextDate];
        //        UIView<JTCalendarWeek> *weekView = [calendarManager.delegateManager buildWeekView];
        //        [weekView setManager:calendarManager];
        //        weekView.backgroundColor = [UIColor blueColor];
        //        weekView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
        //
        //        dayComponent.day = i*7;
        //        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:weekDate options:0];
        //        //weekDate = [_manager.dateHelper firstWeekDayOfMonth:_date];
        //
        //        [weekView setStartDate:nextDate updateAnotherMonth:NO monthDate:[NSDate date]];
        //        //[futureDates addObject:weekView];
        //        //NSLog(@"nextDate: %@ ...", nextDate);
    }
    
    
    
    
    //    /*
    //
    //     UIView<JTCalendarWeek> *weekView = [calendarManager.delegateManager buildWeekView];
    //     //        [_weeksViews addObject:weekView];
    //     //        [self addSubview:weekView];
    //     [weekView setManager:calendarManager];
    //     [weekView setStartDate:[NSDate date] updateAnotherMonth:NO monthDate:[NSDate date]];
    //     */
    //
    //
    //
    //
    //    NSDate* weekDate = [calendarManager.dateHelper firstWeekDayOfWeek:[NSDate date]];
    //    for (int i = 0; i < 24; i++) {
    //        UIView<JTCalendarWeek> *weekView = [calendarManager.delegateManager buildWeekView];
    //        [weekView setManager:calendarManager];
    //        weekView.backgroundColor = [UIColor blueColor];
    //        weekView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
    //
    //        dayComponent.day = i*7;
    //        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:weekDate options:0];
    //        //weekDate = [_manager.dateHelper firstWeekDayOfMonth:_date];
    //
    //        [weekView setStartDate:nextDate updateAnotherMonth:NO monthDate:[NSDate date]];
    //        //[futureDates addObject:weekView];
    //        //NSLog(@"nextDate: %@ ...", nextDate);
    //    }
    
}

- (void) createPastDates {
    pastDates = [NSMutableArray new];
    
    for (int i = 52; i >= 0; i--) {
        
        //dayComponent.day = ((i+1)*7) * (-1);
        dayComponent.day = i * -1;
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:fixedPointDate options:0];
        [pastDates addObject:nextDate];
        //        UIView<JTCalendarWeek> *weekView = [calendarManager.delegateManager buildWeekView];
        //        [weekView setManager:calendarManager];
        //        weekView.backgroundColor = [UIColor blueColor];
        //        weekView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
        //
        //        dayComponent.day = i*7;
        //        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:weekDate options:0];
        //        //weekDate = [_manager.dateHelper firstWeekDayOfMonth:_date];
        //
        //        [weekView setStartDate:nextDate updateAnotherMonth:NO monthDate:[NSDate date]];
        //        //[futureDates addObject:weekView];
        //        //NSLog(@"nextDate: %@ ...", nextDate);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(26) inSection:0];
    [tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    //    NSInteger currentOffset = scrollView.contentOffset.y;
    //    NSInteger maximumOffset = scrollView.contentSize.height - (scrollView.frame.size.height * 2.5f );
    //
    //    if (maximumOffset - currentOffset <= 0) {
    //         NSLog(@"load future");
    //    } else if (scrollView.contentOffset.y < scrollView.frame.size.height * 2.5f ) {
    //        NSLog(@"load previous");
    //    }
    
    //    NSIndexPath *firstVisibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
    //    NSLog(@"first visible cell's section: %i, row: %i", firstVisibleIndexPath.section, firstVisibleIndexPath.row);
    //
    //    if (firstVisibleIndexPath.row < 34) {
    //        [self addPastRemoveFuture];
    //    } else if (firstVisibleIndexPath.row > 72){
    //        [self addFutureRemovePast];
    //    }
}

- (void) addPastRemoveFuture {
    NSLog(@"add new past dates");
    NSLog(@"remove future dates");
    
    //    movingPointDate = [pastDates objectAtIndex:(0)];
    //    [self createPastDatesWithReferencePoint:movingPointDate];
    //    [combinationDates addObjectsFromArray:pastDates];
    //    //[combinationDates removeObjectsInArray:futureDates];
    //
    //    [tableView reloadData];
    
    
}
- (void) addFutureRemovePast {
    NSLog(@"add new future dates");
    NSLog(@"remove past dates");
    
    //get latest future
    movingPointDate = [futureDates objectAtIndex:([futureDates count] - 1)];
    [self createFutureDatesWithReferencePoint:movingPointDate];
    [combinationDates addObjectsFromArray:futureDates];
    //[combinationDates removeObjectsInRange:NSMakeRange(0, 52)];
    //[combinationDates removeObjectsInArray:pastDates];
    [tableView reloadData];
    
}



//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView
//                    withVelocity:(CGPoint)velocity
//             targetContentOffset:(inout CGPoint *)targetContentOffset{
//    NSIndexPath *firstVisibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
//
//    if (velocity.y > 0){
//        NSLog(@"up");
//        if (firstVisibleIndexPath.row > ([combinationDates count] - 72)){
//            //[self addFutureRemovePast];
//        }
//
//    }
//    if (velocity.y < 0){
//        NSLog(@"down");
//        if (firstVisibleIndexPath.row < 34) {
//            //[self addPastRemoveFuture];
//        }
//
//    }
//
//}

- (void) createPastDatesWithReferencePoint:(NSDate*) dateReference{
    
    pastDates = [NSMutableArray new];
    for (int i = 26; i >= 0; i--) {
        dayComponent.day = ((i+1)*7) * (-1);
        //dayComponent.day = -1*i;
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:dateReference options:0];
        [pastDates addObject:nextDate];
    }
}


- (void) createFutureDatesWithReferencePoint:(NSDate*) dateReference{
    futureDates = [NSMutableArray new];
    [futureDates addObject:dateReference];
    for (int i = 0; i < 74; i++) {
        dayComponent.day = (i+1)*7;
        //dayComponent.day = 1*i;
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:dateReference options:0];
        [futureDates addObject:nextDate];
    }
}

//- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
//    //scrollView.contentOffset.y increases as you go down
//    //scrollView.contentSize.height never changes
//    NSLog(@"scrollView.contentOffset.y: %f", scrollView.contentOffset.y);
//    NSLog(@"scrollView.contentSize.height: %f", scrollView.contentSize.height);
//}

@end
