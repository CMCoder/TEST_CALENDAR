//
//  LECCalendarMenuMonthView.h
//  LECCalendar

#import <UIKit/UIKit.h>

#import "LECCalendar.h"

@interface LECCalendarMenuMonthView : UIView

@property (weak, nonatomic) LECCalendar *calendarManager;

- (void)setCurrentDate:(NSDate *)currentDate;

- (void)reloadAppearance;

@end
