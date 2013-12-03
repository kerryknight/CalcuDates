//
//  KKConstants.h
//  CalcuDates
//
//  Created by Kerry Knight on 10/31/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

//Constants
#define SECONDS_IN_AN_HOUR  3600
#define SECONDS_IN_A_DAY    86400
#define SECONDS_IN_A_WEEK   604800
#define SECONDS_IN_A_MONTH  2620512 //using average month of 30.33 days
#define SECONDS_IN_A_YEAR   31536000

//Colors
#define LT_BLUE         [UIColor colorWithRed:172/255.0f green:210/255.0f blue:252/255.0f alpha:1.000]
#define MED_BLUE        [UIColor colorWithRed:142/255.0f green:184/255.0f blue:230/255.0f alpha:1.000]
#define MED_DRK_BLUE    [UIColor colorWithRed:95/255.0f green:142/255.0f blue:195/255.0f alpha:1.000]
#define DRK_BLUE        [UIColor colorWithRed:12/255.0f green:43/255.0f blue:99/255.0f alpha:1.000]

//Date values
#define SECONDS_IN_AN_HOUR  3600
#define SECONDS_IN_A_DAY    86400
#define SECONDS_IN_A_WEEK   604800
#define SECONDS_IN_A_MONTH  2620512 //using average month of 30.33 days
#define SECONDS_IN_A_YEAR   31536000

#define DAYS_IN_A_WEEK   7
#define DAYS_IN_A_MONTH  30.33 
#define DAYS_IN_A_YEAR   365.25

//RevMob
#define REV_MOB_APP_ID                      @"5063a9cfd1a7040800000026"
#define REV_MOB_FULLSCREEN_PLACEMENT_ID     @"50f848fe7293dc0e00000001"
#define REV_MOB_BANNER_PLACEMENT_ID         @"50f848a82af5fe1a00000001"
#define REV_MOB_GAMES_BUTTON_PLACEMENT_ID   @"50f8492a2fb9a21600000001" //ad link

//Both Views
#define kPickerAnimationDuration                0.25   // duration for the animation to slide the date picker into view
#define kDatePickerTag                          99     // view tag identifiying the date picker view
#define kTitleKey                               @"title"   // key for obtaining the data source item's title
#define kDateKey                                @"date"    // key for obtaining the data source item's date value
#define kDATE_PICKER_CELL_HEIGHT                162.0f
#define kHEADER_INSTRUCTION_WHITE_LABEL_HEIGHT  43.0f
#define kCALCULATE_BUTTONS_ROW_HEIGHT           55.0f

//Time Period View
// keep track of which rows have date cells
#define kTimePeriodViewDateStartRow         0
#define kTimePeriodViewDateEndRow           1
#define kTimePeriodViewButtonRow            2
#define kTimePeriodViewDateDifferencesRow   3
#define kDURATIONS_CALCULATIONS_ROW_HEIGHT  165.0f

//New Date View
// keep track of which rows have date cells
#define kNewDateViewDateStartRow           0
#define kNewDateViewDurationEntryRow       1
#define kNewDateViewButtonRow              2
#define kNewDateViewCalculatedEndDateRow   3
#define kEND_DATE_CALCULATION_ROW_HEIGHT   55.0f
#define kDURATION_ENTRY_ROW_HEIGHT         128.0f
