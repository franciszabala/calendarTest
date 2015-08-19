//
//  JTTableCalendarViewController.m
//  CalendarTest
//
//  Created by Francis Zabala on 8/13/15.
//  Copyright (c) 2015 Francis Zabala. All rights reserved.
//

#import "JTTableCalendarViewController.h"
#import "JTCalendarWeek.h"
#import "JTWeekViewCell.h"
#import "JTCalendarFirstDayOfTheMonthView.h"



@interface JTTableCalendarViewController () {
    NSArray *tableViewItems;
    NSMutableArray *pastDates;
    NSMutableArray *futureDates;
    NSDateComponents *dayComponent;
    NSCalendar *theCalendar;
    NSDate *fixedPointDate;
    
    NSDate *movingPointDate;
    
    NSMutableArray *combinationDates;
    
    NSMutableArray *monthOverlayArray;
    
    
    
    CGRect topFrameOpened;
    CGRect topFrameClosed;
    
    NSDate *_dateSelected;
    
    UIView *monthOverlay;
    
    UITableView *monthTableOverlay;
}
@end


@implementation JTTableCalendarViewController

static NSString *WeekViewCellIdentifier = @"WeekViewCellIdentifier";
static NSString *MonthOverlayCellIdentifier = @"MonthOverlayCellIdentifier";
static NSDateFormatter *monthFormatter = nil;

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
    [self.tableView registerClass:[JTWeekViewCell class] forCellReuseIdentifier:WeekViewCellIdentifier];
    
    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    
    monthFormatter = [NSDateFormatter new];
    
    monthFormatter.timeZone = calendarManager.dateHelper.calendar.timeZone;
    monthFormatter.locale = calendarManager.dateHelper.calendar.locale;
        [monthFormatter setDateFormat:@"MMMM"];
    
    monthTableOverlay = [UITableView new];
    monthTableOverlay.delegate = self;
    monthTableOverlay.dataSource = self;
    monthTableOverlay.frame = CGRectMake(0.0f, 65.0f, 320.0f, 480.0f);
    
    monthTableOverlay.alpha = 0.0f;
    monthTableOverlay.tag = 6091;
    [self.view addSubview:monthTableOverlay];
    
    
    CGFloat origY = 65.0f+40.0f;
    //CGFloat origBottom =origY + 150.0f;
    topFrameOpened = CGRectMake(0.0f, origY, 320.0f, 220.0f);
    topFrameClosed = CGRectMake(0.0f, origY, 320.0f, 100.0f);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:topFrameOpened style:UITableViewStylePlain];
    
    fixedPointDate = [NSDate date];
    dayComponent = [[NSDateComponents alloc] init];
    theCalendar = [NSCalendar currentCalendar];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //[self createTableViewItems];
    
    monthOverlay = [UIView new];
    monthOverlay.frame = CGRectMake(0.0f, 65.0f, 320.0f, 480.0f);
    UIColor *monthOverlayColor = [UIColor colorWithRed:117/255.0f green:117/255.0f blue:117/255.0f alpha:0.25f];
    
    
    monthOverlay.backgroundColor = monthOverlayColor;
    monthOverlay.userInteractionEnabled = NO;
   
    

    [calendarManager setDate:fixedPointDate];
     monthOverlayArray = [NSMutableArray new];
    [self createPastDatesWithReferencePoint:[calendarManager.dateHelper firstWeekDayOfWeek:fixedPointDate]];
    [self createFutureDatesWithReferencePoint:[calendarManager.dateHelper firstWeekDayOfWeek:fixedPointDate]];
    
    [self populateMonthOverlayArray];
    
    combinationDates = [NSMutableArray new];
    [combinationDates addObjectsFromArray:pastDates];
    [combinationDates addObjectsFromArray:futureDates];
   
    self.tableView.frame = CGRectMake(0.0f, 65.0f, 320.0f, 480.0f);
    self.tableView.tag = 6090;
    [self.view addSubview:self.tableView];
    

    
}


#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [futureDates count];
    if (tableView.tag == 6090) {
        return [combinationDates count]; //roughly 52 weeks in a year
    } else {
        return [combinationDates count];
    }
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 6090) {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:WeekViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeekViewCellIdentifier];
    }
    
    UIView<JTCalendarWeek> *weekView;
    if ([cell viewWithTag:6526] == nil) {
        //NSLog(@"creating new weekview");
        weekView = [calendarManager.delegateManager buildWeekView];
        [weekView setManager:calendarManager];
        weekView.tag = 6526;
        weekView.frame = cell.frame;
        [weekView setStartDate:[combinationDates objectAtIndex:indexPath.row] updateAnotherMonth:NO monthDate:fixedPointDate];
        [cell.contentView addSubview:weekView];
        
    } else {
        //NSLog(@"old weekview");
        weekView = (UIView<JTCalendarWeek>*)[cell viewWithTag:6526];
        [weekView setStartDate:[combinationDates objectAtIndex:indexPath.row] updateAnotherMonth:NO monthDate:fixedPointDate];
    }
    
    //Doesn't work
    /*
    JTWeekViewCell *cell = (JTWeekViewCell *)[tableView dequeueReusableCellWithIdentifier:WeekViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[JTWeekViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeekViewCellIdentifier];
    }

    UIView<JTCalendarWeek> *weekView;
    weekView = [calendarManager.delegateManager buildWeekView];
            [weekView setManager:calendarManager];
    [weekView setStartDate:[combinationDates objectAtIndex:indexPath.row] updateAnotherMonth:NO monthDate:fixedPointDate];
    
    cell.weekView = weekView;
    */
    
    //Sanity check
    /*
     UIView *derp = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    derp.backgroundColor = [UIColor blueColor];
    NSLog(@"");
    [cell addSubview:derp];
     */
        return cell;
    
    } else {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:WeekViewCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MonthOverlayCellIdentifier];
        }
        
        cell.textLabel.text = [monthOverlayArray objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(26) inSection:0];
    [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}


#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarFirstDayOfTheMonthView *)dayView
{
    
    // Today
    if([calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.firstMonthDayView.hidden = YES;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.firstMonthDayView.hidden = YES;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        
    }
    // Other month
    /*
    else if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
     */
    // Another day of the current month
    else{
        if ([calendarManager.dateHelper isFirstDayOfTheMonth:dayView.date]) {
            dayView.firstMonthDayView.hidden = NO;
        } else {
            dayView.firstMonthDayView.hidden = YES;
        }
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:0.0
                       options:0
                    animations:^{
                        dayView.circleView.hidden = NO;
                        dayView.circleView.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished){
                        NSLog(@"Done!");
                        //[calendarManager reload];
                        [self.tableView reloadData];
                   }];
    // Load the previous or next page if touch a day from another month
    /*
    if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [calendarContentView loadNextPageWithAnimation];
        }
        else{
            [calendarContentView loadPreviousPageWithAnimation];
        }
    }
     */
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar {
    return [JTCalendarFirstDayOfTheMonthView new];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewWillBeginDragging");
    [UIView transitionWithView:monthOverlay
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        [self.view addSubview:monthOverlay];
                        monthOverlay.alpha = 0.50f;
                        monthTableOverlay.alpha = 1.0f;
                        self.tableView.alpha = 0.25f;
                    }
                    completion:nil];
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidEndDecelerating");
    [UIView transitionWithView:monthOverlay
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        monthOverlay.alpha = 0.0f;
                         monthTableOverlay.alpha = 0.0f;
                        self.tableView.alpha = 1.0f;
                    }
                    completion:^(BOOL finished){
                        [monthOverlay removeFromSuperview];
                    }];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView.tag == 6090) {
       // NSLog(@"scrollViewDidScroll at 6090");
        [monthTableOverlay setContentOffset:scrollView.contentOffset];
    }
}

-(void) populateMonthOverlayArray {
    
    for (int i =0; i < [pastDates count]; i++) {
        if ([calendarManager.dateHelper isThirdWeekOfTheMonth:[pastDates objectAtIndex:i]]) {
            [monthOverlayArray addObject:[monthFormatter stringFromDate:[pastDates objectAtIndex:i]]];
        } else {
            [monthOverlayArray addObject:@""];
        }
    }
    
    for (int i =0; i < [futureDates count]; i++) {
        if ([calendarManager.dateHelper isThirdWeekOfTheMonth:[futureDates objectAtIndex:i]]) {
            [monthOverlayArray addObject:[monthFormatter stringFromDate:[futureDates objectAtIndex:i]]];
        } else {
            [monthOverlayArray addObject:@""];
        }
    }
}

@end
