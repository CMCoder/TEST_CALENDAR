//
//  LECCalendarDataCache.h
//  LECCalendar

#import <UIKit/UIKit.h>

@class LECCalendar;

@interface LECCalendarDataCache : NSObject

@property (weak, nonatomic) LECCalendar *calendarManager;

- (void)reloadData;
- (BOOL)haveEvent:(NSDate *)date;

@end
