//
//  LECCalendarContentView.h
//  LECCalendar

#import <UIKit/UIKit.h>

@class LECCalendar;

@interface LECCalendarContentView : UIScrollView

@property (weak, nonatomic) LECCalendar *calendarManager;

@property (strong, nonatomic) NSDate *currentDate;

- (void)reloadData;
- (void)reloadAppearance;

@end
