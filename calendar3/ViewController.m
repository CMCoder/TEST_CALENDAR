//
//  ViewController.m
//  calendar3
//
//  Created by 唐嘉一 on 14/12/24.
//  Copyright (c) 2014年 LEC. All rights reserved.
//

#import "ViewController.h"
#import "LECCalendar.h"
#import "LECLineView.h"

@interface ViewController () <LECCalendarDataSource>

@property (weak, nonatomic) IBOutlet LECCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet LECCalendarContentView *calendarContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@property (strong, nonatomic) LECCalendar *calendar;

@property (nonatomic, strong) NSMutableDictionary *eventsByDate;

@end

@implementation ViewController
@synthesize eventsByDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.calendar = [LECCalendar new];
    self.calendar.currentDateSelected = [NSDate date];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 1.;
        
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, LECCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
                dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            
            return [NSString stringWithFormat:@"%ld\n%@", comps.year, monthText];
        };
        
        __weak ViewController* weakSelf = self;
        self.calendar.calendarAppearance.dayExBlock = ^BOOL(NSDate *date, LECCalendar *jt_calendar, NSArray *arys){
            do {
                if ( !weakSelf.eventsByDate) {
                    break;
                }
                
                NSString *key = [[weakSelf dateFormatter] stringFromDate:date];
                
                for (LECLineView *line in arys) {
                    line.hidden = YES;
                }
                
                if(weakSelf.eventsByDate[key]){
                    NSString *str = (NSString *)weakSelf.eventsByDate[key];
                    
                    if (str.intValue > 4) {
                        for (LECLineView *line in arys) {
                            line.hidden = NO;
                        }
                        return YES;
                    } else {
                        for (int num = 0; num < str.intValue; ++num) {
                            LECLineView *line = [arys objectAtIndex:num];
                            line.hidden = NO;
                        }
                    }
                }
            } while (NO);
            return NO;
        };
    }
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    [self createRandomEvents];
    //[self.calendar setCurrentDate:[NSDate date]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.calendar reloadData]; // Must be call in viewDidAppear
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (IBAction)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}

- (IBAction)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
}

- (BOOL)calendarHaveEvent:(LECCalendar *)calendar date:(NSDate *)date
{
    return NO;
}

- (void)calendarDidDateSelected:(LECCalendar *)calendar date:(NSDate *)date
{
    //NSString *key = [[self dateFormatter] stringFromDate:date];
    //NSArray *events = eventsByDate[key];
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
}

#pragma mark - 
- (void)transitionExample
{
    CGFloat newHeight = 320;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        //NSLog(@"%d, %d, %d, %d", rand(), rand(), rand()%2, rand()/2);
        //        NSDictionary *randdic = @{@"left":[NSString stringWithFormat:@"%d",rand()%2],@"right":[NSString stringWithFormat:@"%d",rand()%2]};
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate setObject:[NSString stringWithFormat:@"%d",rand()%8] forKey:key];
    }
}


@end
