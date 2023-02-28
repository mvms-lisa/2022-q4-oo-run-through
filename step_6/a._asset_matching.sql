-- Asset Matching - Vizio OTTera
-- Update with exact title
update ottera_viewership ov
set ov.ref_id = q.refid, ov.content_provider = q.content_provider, ov.series = q.asset_series, ov.series_id = q.asset_series_id
from (
   select ov.id as qid, ov.title, a.title, a.content_provider as content_provider, ov.id as p_id, a.ref_id as refid, a.series as asset_series, ov.channel as powr_channel_series, a.series_id as asset_series_id
   from ottera_viewership ov
   join dictionary.public.powr_assets a on (ov.title = a.title)
   where ov.quarter = 'q4' and ov.year = 2022 and a.partner = 'POWR' and ov.ref_id is null
  LIMIT 10000
) q 
where ov.id = q.qid 


-- Update by fuzzy match
update ottera_viewership o 
set o.ref_id = q.a_ref_id, o.content_provider = q.cp_name, o.series_id = q.assets_series_id, o.series = q.assets_series
from (
    select o.title as vizio_title, a.title as assets_title, o.channel as powr_channel, a.series as assets_series, a.series_id as assets_series_id, soundex(o.title) t1, soundex(a.title) t2, fuzzy_score(a.title, o.title) v3, fuzzy_score(soundex(o.title), soundex(a.title)) v4 , 
    ((v3*1)+(v4*2))/3 weighted_composite_score,
    o.id as p_id, a.ref_id as a_ref_id, a.content_provider as cp_name
    from ottera_viewership o
    cross join dictionary.public.powr_assets  a
    where quarter = 'q4' and year = 2022 and o.ref_id is null and weighted_composite_score > .9 and a.partner = 'POWR'
    LIMIT 1000
    ) q 
where q.p_id = o.id

-- ottera check
select * from ottera_viewership where year = 2022 and quarter = 'q4' and ref_id is null
order by title