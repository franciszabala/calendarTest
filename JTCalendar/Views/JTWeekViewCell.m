//
//  JTWeekViewCell.m
//  CalendarTest
//
//  Created by Francis Zabala on 8/14/15.
//  Copyright (c) 2015 Francis Zabala. All rights reserved.
//

#import "JTWeekViewCell.h"
#import "JTCalendarWeek.h"

@implementation JTWeekViewCell
@synthesize weekView;
@synthesize date;
@synthesize derp;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Helpers
       //CGSize size = self.contentView.frame.size;
        
  

       // Add Main Label to Content View
       self.weekView = (UIView <JTCalendarWeek>*)[UIView new];
        NSLog(@"self.contentView: %@", NSStringFromCGRect(self.contentView.frame));
        self.weekView.frame =CGRectMake(0.0f, 0.0f, 48.0f, 20.0f);
       [self.contentView addSubview:self.weekView];
       
        //Sanity check
//      UIView *derp2 = [[UIView alloc] initWithFrame:self.contentView.frame];
//      derp2.backgroundColor = [UIColor greenColor];
//      [self.contentView addSubview:derp2];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
    
    //
}

@end
