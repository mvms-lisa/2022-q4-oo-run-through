-- Monday, March 13, 2022
    -- Viewership Uploads
    
-- powr_viewership
    -- fields to update: 
        --  filename, year, quarter, pattern (replace where there is an 'X')

    copy into powr_viewership(
    uid, 
    title, 
    type, 
    channel, 
    views, 
    watch_time_seconds, 
    average_watch_time_seconds, 
    platform, 
    geo, 
    year_month_day,
    quarter,
    year,
    filename
    )   
    from (select t.$1, t.$2, t.$3, t.$4, to_number(REPLACE(t.$5, ','), 12, 2), to_decimal(REPLACE(t.$6,  ','), 12, 2), to_number(REPLACE(REPLACE(t.$7, '-', ''), ','), 16, 6), t.$8, t.$9, t.$10, 'q4', 2022,  'powr_viewership_q4_2022.csv'
    from @oo_viewership t) pattern='.*powr_viewership_q4_2022.*' file_format = nosey_viewership 
    ON_ERROR=SKIP_FILE FORCE=TRUE;

-- POWR CHECK
select * from powr_viewership where year = 2022 and quarter = 'q2'

-- POWR UPDATE
update powr_viewership
set viewership_type = 'VOD', month = 12
where year = 2022 and quarter = 'q4' and year_month_day = 20221201


-- gam_data
    -- fields to update: 
        --  filename, year, quarter, pattern (replace where there is an 'X')

        copy into gam_data (
        advertiser,
        ad_unit,
        month_year,
        advertiser_id,
        ad_unit_id,
        total_code_served,
        total_impressions,
        ad_exchange_revenue,
        quarter, 
        year, 
        filename
        )
        from (select t.$1, t.$2, t.$3, t.$4, t.$5, to_number(REPLACE(t.$6,  ','), 15, 0), to_number(REPLACE(t.$7,  ','), 15, 0), to_number(REPLACE(t.$8,  ','), 15, 2), 'q4', 2022,  'gam_q4_2022.csv'
        from @oo_ad_data t) pattern='.*gam_q4_2022.*' file_format = nosey_viewership 
        ON_ERROR=SKIP_FILE FORCE=TRUE;

-- GAM Data CHECK
select * from gam_data where year = 2022 and quarter = 'q4'

-- GAM Initial Update
update gam_data
set viewership_type = 'VOD', month = 12, year_month_day = 20221201
where year = 2022 and quarter = 'q4' and month_year = 'Dec-22'


-- spotx
    -- fields to update: 
        --  filename, year, quarter, pattern (replace where there is an 'X')
        copy into spotx (
        timestamp,
        channel_name,
        deal_demand_source,
        deal_name,
        placements,
        gross_revenue,
        impressions,
        quarter,
        year,
        filename
        )
        from (select t.$1, t.$2, t.$3, t.$4, to_number(REPLACE(t.$5, ','), 10, 0), to_number(REPLACE(t.$6, ','), 10,5), to_number(REPLACE(t.$7, ','), 12, 0),  'q4', 2022,  'spotx_rev_q4_2022.csv'
        from @oo_revenue t) pattern='.*spotx_rev_q4_2022.*' file_format = nosey_viewership 
        ON_ERROR=SKIP_FILE FORCE=TRUE;

-- SpotX CHECK
select * from spotx where year = 2022 and quarter = 'q4'

-- SpotX UPDATE
update spotx
set viewership_type = 'VOD', year_month_day = 20221201, month = 12
where year = 2022 and quarter = 'q4' and timestamp like '%2022-12%'

 
