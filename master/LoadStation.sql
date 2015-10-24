delete  from station;

insert  into station
select  substr(line, 1, 7) as 'Site', 
        substr(line, 9, 4) as 'Dist', 
        substr(line, 15, 41) as 'SiteName', 
        cast(
            case 
                when substr(line, 56, 8) like '%..%' then NULL
                else substr(line, 56, 8)
            end
        as int) as 'StartYear',
        cast(
            case
                when substr(line, 64, 7) like '%..%' then NULL
                else substr(line, 64, 7)
            end
        as int) as 'EndYear',
        cast(substr(line, 72, 8) as float) as 'Latitude',
        cast(substr(line, 81, 9) as float) as 'Longitude',
        case when substr(line, 91, 14) like '%.....%' then null else substr(line, 91, 14) end as 'Source',
        case when substr(line, 106, 4) = 'null' then null else substr(line, 106, 3) end as 'State',
        case when substr(line, 110, 10) like '%..%' then null else substr(line, 110, 10) end as 'Height',
        case when substr(line, 121, 8) like '%..%' then null else substr(line, 121, 8) end as 'BarHeight',
        case when substr(line, 130, 6) like '%..%' then null else substr(line, 130, 6) end as 'WMO'        
from import limit 4,20112;

