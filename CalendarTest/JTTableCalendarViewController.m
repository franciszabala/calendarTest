//
//  JTTableCalendarViewController.m
//  CalendarTest
//
//  Created by Francis Zabala on 8/13/15.
//  Copyright (c) 2015 Francis Zabala. All rights reserved.
//

#import "JTTableCalendarViewController.h"
#import "JTCalendarWeek.h"
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
    
    CGRect bottomFrameOpened;
    CGRect bottomFrameClosed;
    
    NSDate *_dateSelected;
    
    UIView *monthOverlay;
    
    UITableView *monthTableOverlay;
    UITableView *eventsTable;
}
@end


@implementation JTTableCalendarViewController

static NSString *WeekViewCellIdentifier = @"WeekViewCellIdentifier";
static NSString *MonthOverlayCellIdentifier = @"MonthOverlayCellIdentifier";
static NSDateFormatter *monthFormatter = nil;
static int WEEK_HEIGHT = 44;
static int CALENDAR_TABLE_TAG = 6090;
static int MONTH_TABLE_TAG = 6091;
static int EVENT_TABLE_TAG = 6092;

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
    
    /**needed this as it might show views underneath the view (e.g. ecsliding)**/
    self.view.opaque = YES;
    self.view.alpha = 1.0f;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat origY = 65.0f;
    topFrameOpened = CGRectMake(0.0f, origY, self.view.bounds.size.width, WEEK_HEIGHT * 5.0f);
    topFrameClosed = CGRectMake(0.0f, origY, self.view.bounds.size.width, WEEK_HEIGHT * 2.0f);
    
    
    CGFloat topFrameOpenedYOffset = topFrameOpened.origin.y+topFrameOpened.size.height;
    CGFloat topFrameClosedYOffset = topFrameClosed.origin.y+topFrameClosed.size.height;
    
    bottomFrameOpened = CGRectMake(0.0f, topFrameClosedYOffset, self.view.bounds.size.width, self.view.bounds.size.height - (origY +topFrameClosedYOffset));
    bottomFrameClosed = CGRectMake(0.0f, topFrameOpenedYOffset, self.view.bounds.size.width, self.view.bounds.size.height - (origY +topFrameOpenedYOffset));
    
    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    [calendarManager setDate:fixedPointDate];
    
    monthFormatter = [NSDateFormatter new];
    monthFormatter.timeZone = calendarManager.dateHelper.calendar.timeZone;
    monthFormatter.locale = calendarManager.dateHelper.calendar.locale;
        [monthFormatter setDateFormat:@"MMMM"];
    
    /*date stuff*/
    fixedPointDate = [NSDate date];
    dayComponent = [[NSDateComponents alloc] init];
    theCalendar = [NSCalendar currentCalendar];
    
    [self initMonthTableOverlayView: topFrameClosed];
    [self initCalendarTable: topFrameClosed];
    [self initMonthOverlayView: topFrameClosed];
    [self initEventTableOverlayView: bottomFrameOpened];
    
    [self createTableViewItems];
    
    [self createPastDatesWithReferencePoint:[calendarManager.dateHelper firstWeekDayOfWeek:fixedPointDate]];
    [self createFutureDatesWithReferencePoint:[calendarManager.dateHelper firstWeekDayOfWeek:fixedPointDate]];
    
    [self populateMonthOverlayArray];
    
    combinationDates = [NSMutableArray new];
    [combinationDates addObjectsFromArray:pastDates];
    [combinationDates addObjectsFromArray:futureDates];
    
    
   
    [self.view addSubview:monthTableOverlay];
    [self.view addSubview:monthOverlay];
    [self.view addSubview:self.tableView];
    [self.view addSubview:eventsTable];
    
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
    if (tableView.tag == CALENDAR_TABLE_TAG || tableView.tag == MONTH_TABLE_TAG) {
        return [combinationDates count]; //roughly 52 weeks in a year
    } else  if (tableView.tag == EVENT_TABLE_TAG){
        return [tableViewItems count];
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == CALENDAR_TABLE_TAG || tableView.tag == MONTH_TABLE_TAG) {
        return WEEK_HEIGHT;
    } else  if (tableView.tag == EVENT_TABLE_TAG){
        return 62;
    } else {
        return 22;
    }
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == CALENDAR_TABLE_TAG) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:WeekViewCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeekViewCellIdentifier];
        }
    
        UIView<JTCalendarWeek> *weekView;
        if ([cell viewWithTag:6526] == nil) {
            weekView = [calendarManager.delegateManager buildWeekView];
            [weekView setManager:calendarManager];
            weekView.tag = 6526;
            weekView.frame = cell.frame;
            [weekView setStartDate:[combinationDates objectAtIndex:indexPath.row] updateAnotherMonth:NO monthDate:fixedPointDate];
            [cell.contentView addSubview:weekView];
        
        } else {
            weekView = (UIView<JTCalendarWeek>*)[cell viewWithTag:6526];
            [weekView setStartDate:[combinationDates objectAtIndex:indexPath.row] updateAnotherMonth:NO monthDate:fixedPointDate];
        }
        return cell;
    
    } else if (tableView.tag == MONTH_TABLE_TAG) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:WeekViewCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MonthOverlayCellIdentifier];
        }
        cell.textLabel.text = [monthOverlayArray objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else if (tableView.tag == EVENT_TABLE_TAG) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:WeekViewCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MonthOverlayCellIdentifier];
        }
        cell.textLabel.text = [tableViewItems objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;

    } else {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:WeekViewCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MonthOverlayCellIdentifier];
        }
        cell.textLabel.text = @"EMPTY!!!";
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




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([pastDates count] +1) inSection:0];
    [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [self focusOnVisibleWeek];
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

#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.tag == CALENDAR_TABLE_TAG){
    [UIView transitionWithView:monthOverlay
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        [self.view bringSubviewToFront:monthOverlay];
                        monthOverlay.alpha = 0.50f;
                        monthTableOverlay.alpha = 1.0f;
                        self.tableView.alpha = 0.25f;
                    }
                    completion:nil];
     }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
     [self focusOnVisibleWeek];
}
// sync scroll with overlay
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView.tag == CALENDAR_TABLE_TAG) {
        [monthTableOverlay setContentOffset:scrollView.contentOffset];
    } else {
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.tag == CALENDAR_TABLE_TAG){
        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.frame = topFrameOpened;
            monthOverlay.frame = topFrameOpened;
            monthTableOverlay.frame = topFrameOpened;
            eventsTable.frame = bottomFrameClosed;
        }];
        if (!decelerate) {
            [self focusOnVisibleWeek];
        }
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.frame = topFrameClosed;
            monthOverlay.frame = topFrameClosed;
            monthTableOverlay.frame = topFrameClosed;
            eventsTable.frame = bottomFrameOpened;
        }];
    }
}


-(void) populateMonthOverlayArray {
    monthOverlayArray = [NSMutableArray new];
    
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



- (void) focusOnVisibleWeek {
    NSArray *indexPathsForVisibleRows = [self.tableView indexPathsForVisibleRows];
    double num = (self.tableView.contentOffset.y / WEEK_HEIGHT);
    int intpart = (int)num;
    double decpart = num - intpart;
    //printf("Num = %f, intpart = %d, decpart = %f\n", num, intpart, decpart);
    
    if (decpart > 0.5) {
        [self startOfSunsetMagic:[indexPathsForVisibleRows objectAtIndex:1]];
    } else {
        [self startOfSunsetMagic:[indexPathsForVisibleRows objectAtIndex:0]];
    }
    
}

- (void) startOfSunsetMagic:(NSIndexPath*) indexPath {
    [UIView animateWithDuration:0.2 animations:^{
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
                     completion:^(BOOL finished){
                         //[self.view sendSubviewToBack:monthOverlay];
                         dispatch_queue_t mainQueue = dispatch_get_main_queue();
                         dispatch_async(mainQueue, ^{
                             [self hideCalendarOverlays];
                         });
                         
                     }
     
     ];

}

- (void) hideCalendarOverlays {
    [UIView transitionWithView:monthOverlay
                      duration:0.4
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        monthOverlay.alpha = 0.0f;
                        monthTableOverlay.alpha = 0.0f;
                        self.tableView.alpha = 1.0f;
                    }
                    completion:^(BOOL finished){
                        [self.view sendSubviewToBack:monthOverlay];
                        dispatch_queue_t mainQueue = dispatch_get_main_queue();
                        dispatch_async(mainQueue, ^{
                        });
                        
                    }];

}
#pragma mark - Dates Initialization
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
    for (int i = 0; i < 52; i++) {
        dayComponent.day = (i+1)*7;
        //dayComponent.day = 1*i;
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:dateReference options:0];
        [futureDates addObject:nextDate];
    }
    
}

#pragma mark - Calendar Initialization

- (void) initCalendarTable:(CGRect) frame {
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = CALENDAR_TABLE_TAG;
}

- (void) initMonthTableOverlayView:(CGRect) frame {
    monthTableOverlay = [UITableView new];
    monthTableOverlay.delegate = self;
    monthTableOverlay.dataSource = self;
    monthTableOverlay.frame = frame;
    monthTableOverlay.alpha = 0.0f;
    monthTableOverlay.tag = MONTH_TABLE_TAG;
}

- (void) initEventTableOverlayView:(CGRect) frame {
    eventsTable = [UITableView new];
    eventsTable.delegate = self;
    eventsTable.dataSource = self;
    eventsTable.frame = frame;
    eventsTable.opaque = YES;
    eventsTable.tag = EVENT_TABLE_TAG;
}


- (void) initMonthOverlayView:(CGRect) frame {
    monthOverlay = [UIView new];
    monthOverlay.frame = frame;
    UIColor *monthOverlayColor = [UIColor colorWithRed:117/255.0f green:117/255.0f blue:117/255.0f alpha:0.25f];
    monthOverlay.backgroundColor = monthOverlayColor;
    monthOverlay.userInteractionEnabled = NO;
}



@end
