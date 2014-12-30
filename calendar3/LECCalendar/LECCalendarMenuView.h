//
//  LECCalendarMenuView.h
//  LECCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

@class LECCalendar;

@interface LECCalendarMenuView : UIScrollView

@property (weak, nonatomic) LECCalendar *calendarManager;

@property (strong, nonatomic) NSDate *currentDate;

- (void)reloadAppearance;

@end
