//
//  LECCalendarWeekView.h
//  LECCalendar

#import <UIKit/UIKit.h>

#import "LECCalendar.h"

@interface LECCalendarWeekView : UIView

@property (weak, nonatomic) LECCalendar *calendarManager;

@property (assign, nonatomic) NSUInteger currentMonthIndex;

- (void)setBeginningOfWeek:(NSDate *)date;
- (void)reloadData;
- (void)reloadAppearance;

@end
