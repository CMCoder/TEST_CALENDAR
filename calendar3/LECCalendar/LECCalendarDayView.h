//
//  LECCalendarDayView.h
//  LECCalendar

#import <UIKit/UIKit.h>

#import "LECCalendar.h"

@interface LECCalendarDayView : UIView

@property (weak, nonatomic) LECCalendar *calendarManager;

@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL isOtherMonth;

@property (strong, nonatomic) NSMutableArray *lineViews;

- (void)reloadData;
- (void)reloadAppearance;

@end
