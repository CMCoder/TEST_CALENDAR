//
//  LECCalendar.h
//  LECCalendar

#import <UIKit/UIKit.h>

#import "LECCalendarViewDataSource.h"
#import "LECCalendarAppearance.h"

#import "LECCalendarMenuView.h"
#import "LECCalendarContentView.h"

#import "LECCalendarDataCache.h"

@interface LECCalendar : NSObject<UIScrollViewDelegate>

@property (weak, nonatomic) LECCalendarMenuView *menuMonthsView;
@property (weak, nonatomic) LECCalendarContentView *contentView;

@property (weak, nonatomic) id<LECCalendarDataSource> dataSource;

@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSDate *currentDateSelected;

@property (strong, nonatomic, readonly) LECCalendarDataCache *dataCache;
@property (strong, nonatomic, readonly) LECCalendarAppearance *calendarAppearance;

- (void)reloadData;
- (void)reloadAppearance;

- (void)loadPreviousMonth;
- (void)loadNextMonth;

- (void)setCurrentDateDirectly:(NSDate *)currentDate;
@end
