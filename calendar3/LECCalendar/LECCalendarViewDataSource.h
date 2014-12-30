//
//  LECCalendarDataSource.h
//  LECCalendar

#import <Foundation/Foundation.h>

@class LECCalendar;

@protocol LECCalendarDataSource <NSObject>

- (BOOL)calendarHaveEvent:(LECCalendar *)calendar date:(NSDate *)date;
- (void)calendarDidDateSelected:(LECCalendar *)calendar date:(NSDate *)date;

@optional
- (void)calendarDidLoadPreviousPage;
- (void)calendarDidLoadNextPage;

@end
