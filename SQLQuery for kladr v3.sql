
---------------------------------
/*
ALTER FUNCTION [dbo].[geo_dist] ( @src_lat as float, @src_lon as float, @dst_lat as float, @dst_lon as float ) RETURNS float
AS
BEGIN
	DECLARE @dist as float
	SET @dist = 6371 * 2 * ASIN(
			SQRT(
				POWER( SIN( ( @src_lat - @dst_lat ) * PI()/180 / 2 ), 2 )
				+
				COS( @src_lat * PI()/180 ) * COS( @dst_lat * PI()/180 ) * POWER( SIN( ( @src_lon - @dst_lon ) * PI()/180 / 2 ), 2 )
				)
		)
	RETURN ROUND( @dist, 0 )
END
*/
---------------------------------

drop table [dbo].[data_kladr]

SELECT
	 getdate() as date
	,[insurerKLADR]

	,count(1) as count_pol
	,sum(isnull([Premium],0)) as premium
	,sum( case when isnull([ClaimCountPol],0)>0 then 1 else 0 end ) as count_pol_with_claim
	,sum(isnull([ClaimCountPol],0)) as claim_count
	,sum(isnull([ClaimCountPol_Adj],0)) as claim_count_adj
	,sum(isnull([ClaimSumPol],0)) as claim_sum
	,sum(isnull([PaidSumPol],0)) as paid_sum
	,sum(isnull([ClaimSumPol_Infl],0)) as claim_sum_infl
	,sum(isnull([PaidSumPol_Infl],0)) as paid_sum_infl

	,cast(null as varchar(255)) as [address]
	,cast(null as varchar(255)) as [FullAddress]
	,cast(null as varchar(255)) as [Region]
	,cast(null as varchar(255)) as [Rayon]
	,cast(null as varchar(255)) as [City]
	,cast(null as float) as latitude
	,cast(null as float) as longitude

	,cast(null as float) as count_pol_200
	,cast(null as float) as premium_200
	,cast(null as float) as count_pol_with_claim_200
	,cast(null as float) as claim_count_200
	,cast(null as float) as claim_count_adj_200
	,cast(null as float) as claim_sum_200
	,cast(null as float) as paid_sum_200
	,cast(null as float) as claim_sum_infl_200
	,cast(null as float) as paid_sum_infl_200

	,cast(null as float) as count_pol_500
	,cast(null as float) as premium_500
	,cast(null as float) as count_pol_with_claim_500
	,cast(null as float) as claim_count_500
	,cast(null as float) as claim_count_adj_500
	,cast(null as float) as claim_sum_500
	,cast(null as float) as paid_sum_500
	,cast(null as float) as claim_sum_infl_500
	,cast(null as float) as paid_sum_infl_500

	,cast(null as float) as population_200

	-- Щипицин Н {
	,cast(1 as int) as District_city
	,cast(2 as int) as Area_city
	,cast(null as float) as District_city_dist
	,cast(null as float) as Area_city_dist
	,cast(null as float) as Population_density
	-- Щипицин Н }

into [dbo].[data_kladr]

FROM [dbo].[data_osago]

where
	isnull([insurerKLADR],'') <> ''

group by
	 [insurerKLADR]

update [dbo].[data_kladr]
set
	 [FullAddress] = [CDI_FullKladr].[FullAddress]
	,[Region] = [CDI_FullKladr].[Region]
	,[Rayon] = [CDI_FullKladr].[Rayon]
	,[City] = [CDI_FullKladr].[City]
from [dbo].[CDI_FullKladr]
where [CDI_FullKladr].[Kladr_Code] = [data_kladr].[insurerKLADR]

update [dbo].[data_kladr]
set
	 latitude = convert(float,[data_kladr_upd].latitude)
	,longitude = convert(float,[data_kladr_upd].longitude)
	--,[address] = [data_kladr_upd].adress
from [dbo].[data_kladr_upd] as [data_kladr_upd]
where
	[data_kladr_upd].[kladr] = [data_kladr].[insurerKLADR]
	and [data_kladr].latitude is null

update [dbo].[data_kladr]
set
	 latitude = convert(float,[data_kladr_upd].latitude)
	,longitude = convert(float,[data_kladr_upd].longitude)
	--,[address] = [data_kladr_upd].adress
from [dbo].[data_kladr_upd_0] as [data_kladr_upd]
where
	[data_kladr_upd].[kladr] = [data_kladr].[insurerKLADR]
	and [data_kladr].latitude is null

update [dbo].[data_kladr]
set
	 [address] = [data_kladr_upd].[address]
from [dbo].[data_kladr_upd_1] as [data_kladr_upd]
where
	[data_kladr_upd].[kladr] = [data_kladr].[insurerKLADR]

---------------------------------

drop table [dbo].[data_kladr_kladr]

select
	 k1.[date]

--	,rn.[Region_Code]
	,k1.[insurerKLADR] as [insurerKLADR]
	,k1.[count_pol] as count_pol_1
	,k1.[premium] as premium_1
	,k1.[count_pol_with_claim] as count_pol_with_claim_1
	,k1.[claim_count] as claim_count_1
	,k1.[claim_count_adj] as claim_count_adj_1
	,k1.[claim_sum] as claim_sunm_1
	,k1.[paid_sum] as paid_sum_1
	,k1.[claim_sum_infl] as claim_sum_infl_1
	,k1.[paid_sum_infl] as paid_sum_infl_1
	,k1.[latitude] as latitude_1
	,k1.[longitude] as longitude_1

--	,rn.[Region_Neighbor_Code]
	,k2.[insurerKLADR] as kladr_2
	,k2.[count_pol] as count_pol_2
	,k2.[premium] as premium_2
	,k2.[count_pol_with_claim] as count_pol_with_claim_2
	,k2.[claim_count] as claim_count_2
	,k2.[claim_count_adj] as claim_count_adj_2
	,k2.[claim_sum] as claim_sum_2
	,k2.[paid_sum] as paid_sum_2
	,k2.[claim_sum_infl] as claim_sum_infl_2
	,k2.[paid_sum_infl] as paid_sum_infl_2
	,k2.[latitude] as latitude_2
	,k2.[longitude] as longitude_2

	,[dbo].[geo_dist]( k1.[latitude], k1.[longitude], k2.[latitude], k2.[longitude] ) as dist


into [dbo].[data_kladr_kladr]

from
	[dbo].[data_kladr] as k1

--	left join [dbo].[spr_Region_Neighbor] as rn
--		on left(k1.[insurerKLADR],2) = rn.[Region_Code]

	left join [dbo].[data_kladr] as k2
--		on left(k2.[insurerKLADR],2) = rn.[Region_Neighbor_Code]
		on
			k2.[latitude] between k1.[latitude] - 6 and k1.[latitude] + 6
			and k2.[longitude] between k1.[longitude] - 6/COS(k1.[latitude]*PI()/180) and  k1.[longitude] + 6/COS(k1.[latitude]*PI()/180)

--where
--	rn.[Region_Code] is not null

---------------------------------

update [dbo].[data_kladr]
set
	 count_pol_200 = T.count_pol
	,premium_200 = T.premium
	,count_pol_with_claim_200 = T.count_pol_with_claim
	,claim_count_200 = T.claim_count
	,claim_count_adj_200 = T.claim_count_adj
	,claim_sum_200 = T.claim_sum
	,paid_sum_200 = T.paid_sum
	,claim_sum_infl_200 = T.claim_sum_infl
	,paid_sum_infl_200 = T.paid_sum_infl
from
	(
		select
			 [insurerKLADR]
			,sum([data_kladr_kladr].count_pol_2) as count_pol
			,sum([data_kladr_kladr].premium_2) as premium
			,sum([data_kladr_kladr].count_pol_with_claim_2) as count_pol_with_claim
			,sum([data_kladr_kladr].claim_count_2) as claim_count
			,sum([data_kladr_kladr].claim_count_adj_2) as claim_count_adj
			,sum([data_kladr_kladr].claim_sum_2) as claim_sum
			,sum([data_kladr_kladr].paid_sum_2) as paid_sum
			,sum([data_kladr_kladr].claim_sum_infl_2) as claim_sum_infl
			,sum([data_kladr_kladr].paid_sum_infl_2) as paid_sum_infl
		from [dbo].[data_kladr_kladr]
		where isnull(dist,10000) <= 200
		group by [insurerKLADR]
	) as T
where T.[insurerKLADR] = [data_kladr].[insurerKLADR]

update [dbo].[data_kladr]
set
	 count_pol_500 = T.count_pol
	,premium_500 = T.premium
	,count_pol_with_claim_500 = T.count_pol_with_claim
	,claim_count_500 = T.claim_count
	,claim_count_adj_500 = T.claim_count_adj
	,claim_sum_500 = T.claim_sum
	,paid_sum_500 = T.paid_sum
	,claim_sum_infl_500 = T.claim_sum_infl
	,paid_sum_infl_500 = T.paid_sum_infl
from
	(
		select
			 [insurerKLADR]
			,sum([data_kladr_kladr].count_pol_2) as count_pol
			,sum([data_kladr_kladr].premium_2) as premium
			,sum([data_kladr_kladr].count_pol_with_claim_2) as count_pol_with_claim
			,sum([data_kladr_kladr].claim_count_2) as claim_count
			,sum([data_kladr_kladr].claim_count_adj_2) as claim_count_adj
			,sum([data_kladr_kladr].claim_sum_2) as claim_sum
			,sum([data_kladr_kladr].paid_sum_2) as paid_sum
			,sum([data_kladr_kladr].claim_sum_infl_2) as claim_sum_infl
			,sum([data_kladr_kladr].paid_sum_infl_2) as paid_sum_infl
		from [dbo].[data_kladr_kladr]
		where isnull(dist,10000) <= 500
		group by [insurerKLADR]
	) as T
where T.[insurerKLADR] = [data_kladr].[insurerKLADR]

---------------------------------
/*
alter table [dbo].[data_osago]
add
	 latitude float
	,longitude float
*/

update [dbo].[data_osago]
set
	 latitude = [data_kladr].latitude
	,longitude = [data_kladr].longitude
from [dbo].[data_kladr]
where [data_osago].[insurerKLADR] = [data_kladr].[insurerKLADR]

---------------------------------
/*
alter table [dbo].[data_osago]
add
	 count_pol_200 float
	,count_pol_with_claim_200 float
	,claim_count_200 float
	,claim_count_adj_200 float
	,claim_sum_200 float
	,paid_sum_200 float
	,claim_sum_infl_200 float
	,paid_sum_infl_200 float

	,count_pol_500 float
	,count_pol_with_claim_500 float
	,claim_count_500 float
	,claim_count_adj_500 float
	,claim_sum_500 float
	,paid_sum_500 float
	,claim_sum_infl_500 float
	,paid_sum_infl_500 float
*/

update [dbo].[data_osago]
set
	 count_pol_200 = [data_kladr].count_pol_200
	,count_pol_with_claim_200 = [data_kladr].count_pol_with_claim_200
	,claim_count_200 = [data_kladr].claim_count_200
	,claim_count_adj_200 = [data_kladr].claim_count_adj_200
	,claim_sum_200 = [data_kladr].claim_sum_200
	,paid_sum_200 = [data_kladr].paid_sum_200
	,claim_sum_infl_200 = [data_kladr].claim_sum_infl_200
	,paid_sum_infl_200 = [data_kladr].paid_sum_infl_200

	,count_pol_500 = [data_kladr].count_pol_500
	,count_pol_with_claim_500 = [data_kladr].count_pol_with_claim_500
	,claim_count_500 = [data_kladr].claim_count_500
	,claim_count_adj_500 = [data_kladr].claim_count_adj_500
	,claim_sum_500 = [data_kladr].claim_sum_500
	,paid_sum_500 = [data_kladr].paid_sum_500
	,claim_sum_infl_500 = [data_kladr].claim_sum_infl_500
	,paid_sum_infl_500 = [data_kladr].paid_sum_infl_500

from [dbo].[data_kladr]
where [data_osago].[insurerKLADR] = [data_kladr].[insurerKLADR]

---------------------------------
/*
alter table [dbo].[data_osago_claims]
add
	 latitude float
	,longitude float
*/

update [dbo].[data_osago_claims]
set
	 latitude = [data_kladr].latitude
	,longitude = [data_kladr].longitude
from [dbo].[data_kladr]
where [data_osago_claims].[insurerKLADR] = [data_kladr].[insurerKLADR]

---------------------------------
/*
alter table [dbo].[data_osago_claims]
add
	 count_pol_200 float
	,count_pol_with_claim_200 float
	,claim_count_200 float
	,claim_count_adj_200 float
	,claim_sum_200 float
	,paid_sum_200 float
	,claim_sum_infl_200 float
	,paid_sum_infl_200 float

	,count_pol_500 float
	,count_pol_with_claim_500 float
	,claim_count_500 float
	,claim_count_adj_500 float
	,claim_sum_500 float
	,paid_sum_500 float
	,claim_sum_infl_500 float
	,paid_sum_infl_500 float
*/

update [dbo].[data_osago_claims]
set
	 count_pol_200 = [data_kladr].count_pol_200
	,count_pol_with_claim_200 = [data_kladr].count_pol_with_claim_200
	,claim_count_200 = [data_kladr].claim_count_200
	,claim_count_adj_200 = [data_kladr].claim_count_adj_200
	,claim_sum_200 = [data_kladr].claim_sum_200
	,paid_sum_200 = [data_kladr].paid_sum_200
	,claim_sum_infl_200 = [data_kladr].claim_sum_infl_200
	,paid_sum_infl_200 = [data_kladr].paid_sum_infl_200

	,count_pol_500 = [data_kladr].count_pol_500
	,count_pol_with_claim_500 = [data_kladr].count_pol_with_claim_500
	,claim_count_500 = [data_kladr].claim_count_500
	,claim_count_adj_500 = [data_kladr].claim_count_adj_500
	,claim_sum_500 = [data_kladr].claim_sum_500
	,paid_sum_500 = [data_kladr].paid_sum_500
	,claim_sum_infl_500 = [data_kladr].claim_sum_infl_500
	,paid_sum_infl_500 = [data_kladr].paid_sum_infl_500

from [dbo].[data_kladr]
where [data_osago_claims].[insurerKLADR] = [data_kladr].[insurerKLADR]

---------------------------------
/*
alter table [dbo].[DB_Quotes]
add
	 latitude float
	,longitude float
*/

update [dbo].[DB_Quotes]
set
	 latitude = [data_kladr].latitude
	,longitude = [data_kladr].longitude
from [dbo].[data_kladr]
where [DB_Quotes].[OwnerKLADRCode] = [data_kladr].[insurerKLADR]

---------------------------------
/*
alter table [dbo].[DB_Quotes]
add
	 count_pol_200 float
	,count_pol_with_claim_200 float
	,claim_count_200 float
	,claim_count_adj_200 float
	,claim_sum_200 float
	,paid_sum_200 float
	,claim_sum_infl_200 float
	,paid_sum_infl_200 float

	,count_pol_500 float
	,count_pol_with_claim_500 float
	,claim_count_500 float
	,claim_count_adj_500 float
	,claim_sum_500 float
	,paid_sum_500 float
	,claim_sum_infl_500 float
	,paid_sum_infl_500 float
*/

update [dbo].[DB_Quotes]
set
	 count_pol_200 = [data_kladr].count_pol_200
	,count_pol_with_claim_200 = [data_kladr].count_pol_with_claim_200
	,claim_count_200 = [data_kladr].claim_count_200
	,claim_count_adj_200 = [data_kladr].claim_count_adj_200
	,claim_sum_200 = [data_kladr].claim_sum_200
	,paid_sum_200 = [data_kladr].paid_sum_200
	,claim_sum_infl_200 = [data_kladr].claim_sum_infl_200
	,paid_sum_infl_200 = [data_kladr].paid_sum_infl_200

	,count_pol_500 = [data_kladr].count_pol_500
	,count_pol_with_claim_500 = [data_kladr].count_pol_with_claim_500
	,claim_count_500 = [data_kladr].claim_count_500
	,claim_count_adj_500 = [data_kladr].claim_count_adj_500
	,claim_sum_500 = [data_kladr].claim_sum_500
	,paid_sum_500 = [data_kladr].paid_sum_500
	,claim_sum_infl_500 = [data_kladr].claim_sum_infl_500
	,paid_sum_infl_500 = [data_kladr].paid_sum_infl_500

from [dbo].[data_kladr]
where
	[DB_Quotes].[OwnerKLADRCode] = [data_kladr].[insurerKLADR]
	and [DB_Quotes].[count_pol_200] is null

---------------------------------

drop table [dbo].[data_cities]
drop table [dbo].[data_kladr_cities]

select
	 avg([longitude]) as [longitude]
	,avg([latitude]) as [latitude]
	,replace(replace([region],'ё','е'),'Ё','Е') as [region]
	,replace(replace([name],'ё','е'),'Ё','Е') as [name]
	,max(isnull([population],0)) as [population]
into [dbo].[data_cities]
from [dbo].[data_cities_upd]
group by
	 [region]
	,[name]

select
	 k1.[date]

	,k1.[insurerKLADR] as kladr_1
	,k1.[latitude] as latitude_1
	,k1.[longitude] as longitude_1

	,c.[region]
	,c.[name]
	,c.[population]
	,c.[latitude] as latitude_c
	,c.[longitude] as longitude_c

	,[dbo].[geo_dist]( k1.[latitude], k1.[longitude], c.[latitude], c.[longitude] ) as dist


into [dbo].[data_kladr_cities]

from
	[dbo].[data_kladr] as k1
	left join [dbo].[data_cities] as c
		on
			c.[latitude] between k1.[latitude] - 6 and k1.[latitude] + 6
			and c.[longitude] between k1.[longitude] - 6/COS(k1.[latitude]*PI()/180) and  k1.[longitude] + 6/COS(k1.[latitude]*PI()/180)

update [dbo].[data_kladr]
set
	 population_200 = T.[population]
from
	(
		select
			 [kladr_1]
			,sum(isnull([data_kladr_cities].[population],0)) as [population]
		from [dbo].[data_kladr_cities]
		where isnull(dist,10000) <= 200
		group by [kladr_1]
	) as T
where T.[kladr_1] = [data_kladr].[insurerKLADR]

/*
alter table [dbo].[data_osago]
add
	 population_200 float
*/

update [dbo].[data_osago]
set
	 population_200 = [data_kladr].population_200
from [dbo].[data_kladr]
where [data_osago].[insurerKLADR] = [data_kladr].[insurerKLADR]

/*
alter table [dbo].[data_osago_claims]
add
	 population_200 float
*/

update [dbo].[data_osago_claims]
set
	 population_200 = [data_kladr].population_200
from [dbo].[data_kladr]
where [data_osago_claims].[insurerKLADR] = [data_kladr].[insurerKLADR]

/*
alter table [dbo].[DB_Quotes]
add
	 population_200 float
*/

update [dbo].[DB_Quotes]
set
	 population_200 = [data_kladr].population_200
from [dbo].[data_kladr]
where
	[DB_Quotes].[OwnerKLADRCode] = [data_kladr].[insurerKLADR]
	and [DB_Quotes].population_200 is null

---------------------------------
-- Щипицин Н {

drop table [dbo].[data_kladr_city]

select

	 k1.[date]
	,k1.[insurerKLADR] as insurerKLADR
	,k1.[count_pol] as count_pol_1
	,k1.[premium] as premium_1
	,k1.[count_pol_with_claim] as count_pol_with_claim_1
	,k1.[claim_count] as claim_count_1
	,k1.[claim_count_adj] as claim_count_adj_1
	,k1.[claim_sum] as claim_sunm_1
	,k1.[paid_sum] as paid_sum_1
	,k1.[claim_sum_infl] as claim_sum_infl_1
	,k1.[paid_sum_infl] as paid_sum_infl_1
	,k1.[latitude] as latitude_1
	,k1.[longitude] as longitude_1

	,k2.[Код ФИАС] as Code_FIAS
	,k2.[Признак центра района или региона] as Feature_district_center
	,k2.[Население] as Population_district
	,k2.[Федеральный округ] as Federal_district

	,[dbo].[geo_dist]( k1.[latitude], k1.[longitude], k2.Широта, k2.Долгота ) as dist
	
into [dbo].[data_kladr_city]

from
	[dbo].[data_kladr] as k1
	left join [dbo].City_district as k2
		on
			k2.Широта between k1.[latitude] - 6 and k1.[latitude] + 6
			and k2.Долгота between k1.[longitude] - 6/COS(k1.[latitude]*PI()/180) and  k1.[longitude] + 6/COS(k1.[latitude]*PI()/180)

update data_kladr

	set District_city_dist = isnull(f.dist, 100)

	from data_kladr as k 

	left join 
	(
	select top_feature.*, c.dist from (
	select insurerKLADR, case when Feature_district_center = 3 then 2 else Feature_district_center end as Feature_district_center, max(Population_district) as m_Population_district from [data_kladr_city]
	where dist <= 200
	group by insurerKLADR, case when Feature_district_center = 3 then 2 else Feature_district_center end ) as top_feature

	left join [data_kladr_city] as c
	on top_feature.m_Population_district = c.Population_district
		and top_feature.insurerKLADR = c.insurerKLADR
		and top_feature.Feature_district_center = c.Feature_district_center ) as f

	on k.insurerKLADR = f.insurerKLADR

	where Feature_district_center = 1
	
update data_kladr

	set Area_city_dist = isnull(f.dist, 200)

	from data_kladr as k 

	left join 
	(
	select top_feature.*, c.dist from (
	select insurerKLADR, case when Feature_district_center = 3 then 2 else Feature_district_center end as Feature_district_center, max(Population_district) as m_Population_district from [data_kladr_city]
	where dist <= 200
	group by insurerKLADR, case when Feature_district_center = 3 then 2 else Feature_district_center end ) as top_feature

	left join [data_kladr_city] as c
	on top_feature.m_Population_district = c.Population_district
	and top_feature.insurerKLADR = c.insurerKLADR
	and top_feature.Feature_district_center = c.Feature_district_center ) as f
	on k.insurerKLADR = f.insurerKLADR

	where Feature_district_center = 2
	

	
/*
alter table [dbo].[data_kladr]
add
	 Population_district float
*/

update data_kladr

	set Population_district = isnull(f.Population_district, 300000)

	from data_kladr as k 

	left join 
	(select distinct insurerKLADR, Population_district from data_kladr_city) as f

	on k.insurerKLADR = f.insurerKLADR

/*
alter table [dbo].data_osago_claims
add
	Population_Area_city float
	, District_city_dist float
	,Area_city_dist float
	,Population_District_city float
*/

update data_osago_claims

	set District_city_dist = isnull(d.District_city_dist, 101),
		Area_city_dist = isnull(d.Area_city_dist, 201),
		Population_District_city = isnull(d.Population_district, 300000)

	from data_osago_claims as c

	left join data_kladr as d
	on c.insurerKLADR = d.insurerKLADR

/*
alter table [dbo].DB_Quotes
add
	Population_Area_city float
	 ,District_city_dist float
	,Area_city_dist float
	,Population_District_city float
*/

update DB_Quotes

set District_city_dist = isnull(d.District_city_dist, 101),
		Area_city_dist = isnull(d.Area_city_dist, 201)

	from DB_Quotes as c

	left join data_kladr as d
	on c.OwnerKLADRCode = d.insurerKLADR

/*
alter table [dbo].data_osago
add
	Population_Area_city float
	, District_city_dist float
	, Area_city_dist float
	, Population_District_city float
	
*/

update data_osago
	
set District_city_dist = isnull(d.District_city_dist, 101),
		Area_city_dist = isnull(d.Area_city_dist, 201)

	from data_osago as c

	left join data_kladr as d
	on c.insurerKLADR = d.insurerKLADR 


update data_osago
	
set Population_District_city = isnull(d.m_Population_district, 100000)

	from data_osago as c

	left join (
select s.insurerKLADR, s.dist, cast(replace(replace( s.m_Population_district, ']', ''), '[', '' ) as int) as m_Population_district from (
            select top_feature.*, c.dist from (
            select insurerKLADR, case when Feature_district_center = 3 then 2 else Feature_district_center end as Feature_district_center, max(Population_district) as m_Population_district from [data_kladr_city]
            where dist <= 200
            group by insurerKLADR, case when Feature_district_center = 3 then 2 else Feature_district_center end ) as top_feature
            left join [data_kladr_city] as c
            on top_feature.m_Population_district = c.Population_district
                and top_feature.insurerKLADR = c.insurerKLADR
                and top_feature.Feature_district_center = c.Feature_district_center ) as s) as d
	on c.insurerKLADR = d.insurerKLADR 

update DB_Quotes
	
set Population_District_city = isnull(d.m_Population_district, 100000)

	from DB_Quotes as c

	left join (
select s.insurerKLADR, s.dist, cast(replace(replace( s.m_Population_district, ']', ''), '[', '' ) as int) as m_Population_district from (
            select top_feature.*, c.dist from (
            select insurerKLADR, case when Feature_district_center = 3 then 2 else Feature_district_center end as Feature_district_center, max(Population_district) as m_Population_district from [data_kladr_city]
            where dist <= 200
            group by insurerKLADR, case when Feature_district_center = 3 then 2 else Feature_district_center end ) as top_feature
            left join [data_kladr_city] as c
            on top_feature.m_Population_district = c.Population_district
                and top_feature.insurerKLADR = c.insurerKLADR
                and top_feature.Feature_district_center = c.Feature_district_center ) as s) as d
	on c.OwnerKLADRCode = d.insurerKLADR 

update data_osago_claims
	
set Population_District_city = isnull(d.m_Population_district, 100000)

	from data_osago_claims as c

	left join (
select s.insurerKLADR, s.dist, cast(replace(replace( s.m_Population_district, ']', ''), '[', '' ) as int) as m_Population_district from (
            select top_feature.*, c.dist from (
            select insurerKLADR, case when Feature_district_center = 3 then 2 else Feature_district_center end as Feature_district_center, max(Population_district) as m_Population_district
			 from [data_kladr_city]
            where dist <= 200
            group by insurerKLADR, case when Feature_district_center = 3 then 2 else Feature_district_center end ) as top_feature
            left join [data_kladr_city] as c
            on top_feature.m_Population_district = c.Population_district
                and top_feature.insurerKLADR = c.insurerKLADR
                and top_feature.Feature_district_center = c.Feature_district_center ) as s) as d
	on c.insurerKLADR = d.insurerKLADR 
	
update data_osago
	
set Population_Area_city = isnull(a.m_Population_district, 1000000)

	from data_osago as c
	left join [dbo].[area_table] as a
	on c.insurerKLADR = a.insurerKLADR
	
update data_osago_claims
	
set Population_Area_city = isnull(a.m_Population_district, 1000000)

	from data_osago_claims as c
	left join [dbo].[area_table] as a
	on c.insurerKLADR = a.insurerKLADR

update DB_Quotes
	
set Population_Area_city = isnull(a.m_Population_district, 1000000)

	from DB_Quotes as c
	left join [dbo].[area_table] as a
	on c.OwnerKLADRCode = a.insurerKLADR


/*
alter table [dbo].data_osago
add
	Population_density_Subject float
	, Population_density_FO float
	, Population_Subject float
*/

update data_osago
	
set Population_density_Subject = cast(isnull(a.Population_density_Subject, 26.97) as float)
	, Population_density_FO = cast(isnull(a.Population_density_FO, 27.45) as float)
	, Population_Subject = cast(isnull(a.Population_Subject, 1740000) as float)

	from data_osago as c
	left join (select cast(isnull(f.Population_density, 26.97) as float) as Population_density_Subject,
    			cast(isnull(f.Population_FO, 27.45) as float) as Population_density_FO,
    			cast(isnull(f.Population, 1740000) as float) as Population_Subject,
    			f.Code_district
    		from Population as f) as a
	on left(c.insurerKLADR, 2) = a.Code_district

/*
alter table [dbo].data_osago_claims
add
	Population_density_Subject float
	, Population_density_FO float
	, Population_Subject float
*/

update data_osago_claims
	
set Population_density_Subject = cast(isnull(a.Population_density_Subject, 26.97) as float)
	, Population_density_FO = cast(isnull(a.Population_density_FO, 27.45) as float)
	, Population_Subject = cast(isnull(a.Population_Subject, 1740000) as float)

	from data_osago_claims as c
	left join (select cast(isnull(f.Population_density, 26.97) as float) as Population_density_Subject,
    			cast(isnull(f.Population_FO, 27.45) as float) as Population_density_FO,
    			cast(isnull(f.Population, 1740000) as float) as Population_Subject,
    			f.Code_district
    		from Population as f) as a
	on left(c.insurerKLADR, 2) = a.Code_district
		
/*
alter table [dbo].DB_Quotes
add
	Population_density_Subject float
	, Population_density_FO float
	, Population_Subject float
*/

update DB_Quotes
	
set Population_density_Subject = cast(isnull(a.Population_density_Subject, 26.97) as float)
	, Population_density_FO = cast(isnull(a.Population_density_FO, 27.45) as float)
	, Population_Subject = cast(isnull(a.Population_Subject, 1740000) as float)

	from DB_Quotes as c
	left join (select cast(isnull(f.Population_density, 26.97) as float) as Population_density_Subject,
    			cast(isnull(f.Population_FO, 27.45) as float) as Population_density_FO,
    			cast(isnull(f.Population, 1740000) as float) as Population_Subject,
    			f.Code_district
    		from Population as f) as a
	on left(c.OwnerKLADRCode, 2) = a.Code_district
		
/*
alter table [dbo].data_osago_claims
add
	IsCity float
	, InsurerOwner float
*/

update data_osago_claims 
	
	set IsCity = isnull(f.isCity, 0)
	
	from data_osago_claims as q
	left join
	(SELECT 1 as isCity, code FROM [Scoring_OSAGO_TEST].[dbo].[KLADR_CDI] where [SOCR] = 'г') as f
	on q.insurerKLADR = f.CODE

update data_osago_claims 
	
	set InsurerOwner = isnull(i.insurer_Owner, 1)
	
	from data_osago_claims as q
	left join
	(SELECT id, case when insurer_Owner = 'true' then 1 else 0 end as insurer_Owner FROM [Scoring_OSAGO_TEST].[dbo].[icra_sales_full_new]) as i
	on q.id = i.id
	
/*
alter table [dbo].data_osago
add
	IsCity float
	, InsurerOwner float
*/

update data_osago 
	
	set IsCity = isnull(f.isCity, 0)
	
	from data_osago as q
	left join
	(SELECT 1 as isCity, code FROM [Scoring_OSAGO_TEST].[dbo].[KLADR_CDI] where [SOCR] = 'г') as f
	on q.insurerKLADR = f.CODE

update data_osago 
	
	set InsurerOwner = isnull(i.insurer_Owner_num, 1)
	
	from data_osago as q
	left join
	(SELECT id, case when insurer_Owner = 'true' then 1 else 0 end as insurer_Owner_num FROM [Scoring_OSAGO_TEST].[dbo].[icra_sales_full_new]) as i
	on q.id = i.id

/*
alter table [dbo].DB_Quotes
add
	IsCity float
	, InsurerOwner float
*/

update DB_Quotes 
	
	set IsCity = isnull(f.isCity, 0)
	
	from DB_Quotes as q
	left join
	(SELECT 1 as isCity, code FROM [Scoring_OSAGO_TEST].[dbo].[KLADR_CDI] where [SOCR] = 'г') as f
	on q.OwnerKLADRCode = f.CODE

update DB_Quotes 
	
	set InsurerOwner = isnull(i.insurer_Owner, 1)
	
	from DB_Quotes as q
	left join
	(SELECT id, case when insurer_Owner = 'true' then 1 else 0 end as insurer_Owner FROM [Scoring_OSAGO_TEST].[dbo].[icra_sales_full_new]) as i
	on q.PolicyId = i.id

-- Щипицин Н }
---------------------------------



			
