//
//  LECCalendarMonthView.h
//  LECCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

#import "LECCalendar.h"

@interface LECCalendarMonthView : UIView

@property (weak, nonatomic) LECCalendar *calendarManager;

- (void)setBeginningOfMonth:(NSDate *)date;
- (void)reloadData;
- (void)reloadAppearance;

@end
