-- in order to group our data properly, we need to be able to determine which 'department' a record belongs to
-- departments in this case refer to platforms: roku, firetv, ios, etc.  

-- step 2 is to update the department_id's of the records that were just uploaded 


-- powr_viewership
update powr_viewership p
    -- set device id column to val in query, set dept id to val in query
    set p.device_id = q.devid, p.department_id = q.depid
    from 
    (
        -- query to match viewership record to the device
        select p.id as qid, d.device_id as devid, d.department_id as depid from powr_viewership p
        join dictionary.public.devices d on (d.entry = p.platform)
        where year = 2022 and quarter = 'q4'
    ) q
    -- update where the record id matches the record id in query
    where p.id = q.qid

    -- Delete undefined platforms and titles = none 
delete from powr_viewership where year = 2022 and quarter = 'q4' and (type = 'none' or type = 'extra' or type = 'trailer')

select * from powr_viewership where year = 2022 and quarter = 'q4'


-- spotx 
    update spotx s
    -- set channel id column to val in query, set dept id to val in query
    set s.channel_id = q.chid, s.department_id = q.depid
    from
    (
        -- query to match viewership record to the channel
        select s.id as qid,  c.id as chid, c.department_id as depid from spotx s
        join dictionary.public.spotx_channels c on (c.name = s.channel_name)
        where year = 2022 and quarter = 'q4' 
    ) q
    -- update where the record id matches the record id in query
    where s.id = q.qid
    
    
    
    update spotx s
    -- set channel id column to val in query, set dept id to val in query
    set s.device_id = q.did, s.department_id = q.depid
    from
    (
        -- query to match viewership record to the channel
        select s.id as qid,  d.device_id as did, d.department_id as depid from spotx s
        join dictionary.public.devices d on (d.entry = s.channel_name)
        where year = 2022 and quarter = 'q4' 
    ) q
    -- update where the record id matches the record id in query
    where s.id = q.qid

select * from spotx where year = 2022 and quarter = 'q4' 


-- gam_data 
    update gam_data g
    -- set device id column to val in query, set dept id to val in query
    set g.device_id = q.devid, g.department_id = q.depid
    from 
    (
        -- query to match viewership record to the device
        select g.id as qid, d.id as devid, d.department_id as depid from gam_data g
        join dictionary.public.devices d on (d.entry = g.ad_unit)
        where year = 2022 and quarter = 'q4'
    ) q
    -- update where the record id matches the record id in query
    where g.id = q.qid

select * from gam_data where year = 2022 and quarter = 'q4' 