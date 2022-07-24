--Chalange 4--
-- JSON --

--import file into Variant table
create or replace Stage FROSTYJSON
URL = 's3://frostyfridaychallenges/'
file_format = (type=JSON);

list @FROSTYJSON/challenge_4/;

Create table Spanish_Monarchs (payload variant);

create or replace file format frosty_json_format
  type = 'JSON'
  strip_outer_array = true;

copy into Spanish_Monarchs
from @FROSTYJSON/challenge_4/
file_format = frosty_json_format
;

select $1 from spanish_monarchs;
--Truncate SPANISH_MONARCHS;

-- create view over variant table --

create view v_SPANISH_MONARCHS as (
    
SELECT 
row_number() over(order by M.value:Birth::DATE asc) as ID,
M.index+1 as inter_house_id,
payload:Era::STRING ERA,
H.value:House::STRING HOUSE,
M.value:Name::STRING NAME,
M.value:Nickname[0]::STRING as Nickname_1,
M.value:Nickname[1]::STRING as Nickname_2,
M.value:Nickname[2]::STRING as Nickname_3,
M.value:Birth::DATE BIRTH,
M.value:"Place of Birth"::STRING PLACE_OF_BIRTH,
M.value:"Consort\/Queen Consort"[0]::STRING as Queen_or_Queen_Constort_1,
M.value:"Consort\/Queen Consort"[1]::STRING as Queen_or_Queen_Constort_2,
M.value:"Consort\/Queen Consort"[2]::STRING as Queen_or_Queen_Constort_3,
M.value:"End of Reign"::Date END_OF_REIGN,
M.value:"Duration"::String DURATION,
M.value:"Death"::DATE DEATH,
split_part(M.value:"Age at Time of Death"::String,' ',0)::number AGE_AT_TIME_OF_DEATH_YEARS,
M.value:"Place of Death"::String PLACE_OF_DEATH,
M.value:"Burial Place"::String BURIAL_PLACE
-- M.*

from SPANISH_MONARCHS sm,
lateral Flatten(input => payload:Houses) H,
lateral Flatten(input => H.value:Monarchs) M
order by ID
    
    )
;

select * 
FROM 
v_SPANISH_MONARCHS
limit 100;



