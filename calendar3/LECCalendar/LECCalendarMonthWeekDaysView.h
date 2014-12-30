//
//  LECCalendarMonthWeekDaysView.h
//  LECCalendar

#import <UIKit/UIKit.h>

#import "LECCalendar.h"

@interface LECCalendarMonthWeekDaysView : UIView

@property (weak, nonatomic) LECCalendar *calendarManager;

+ (void)beforeReloadAppearance;
- (void)reloadAppearance;

@end
