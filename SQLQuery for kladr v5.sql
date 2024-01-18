
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

drop table [dbo].[data_kladr_20210706]

SELECT
	 getdate() as date
	,[OwnerKLADRCode]

	,count(1) as count_pol
	,sum(isnull([Premium],0)) as premium
	,sum( case when isnull([ClaimCountPol],0)>0 then 1 else 0 end ) as count_pol_with_claim
	,sum(isnull([ClaimCountPol],0)) as claim_count
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
	,cast(null as float) as claim_sum_200
	,cast(null as float) as paid_sum_200
	,cast(null as float) as claim_sum_infl_200
	,cast(null as float) as paid_sum_infl_200

	,cast(null as float) as count_pol_500
	,cast(null as float) as premium_500
	,cast(null as float) as count_pol_with_claim_500
	,cast(null as float) as claim_count_500
	,cast(null as float) as claim_sum_500
	,cast(null as float) as paid_sum_500
	,cast(null as float) as claim_sum_infl_500
	,cast(null as float) as paid_sum_infl_500

	,cast(null as float) as population_200

	-- ������� � {
	,cast(1 as int) as District_city
	,cast(2 as int) as Area_city
	,cast(null as float) as District_city_dist
	,cast(null as float) as Area_city_dist
	,cast(null as float) as Population_density
	-- ������� � }

into [dbo].[data_kladr_20210706]
FROM [dbo].[data_osago]
where
	isnull([OwnerKLADRCode],'') <> ''
group by
	 [OwnerKLADRCode]

update [dbo].[data_kladr_20210706]
set
	 [FullAddress] = [CDI_FullKladr].[FullAddress]
	,[Region] = [CDI_FullKladr].[Region]
	,[Rayon] = [CDI_FullKladr].[Rayon]
	,[City] = [CDI_FullKladr].[City]
from [dbo].[CDI_FullKladr]
where [CDI_FullKladr].[Kladr_Code] = [data_kladr_20210706].[OwnerKLADRCode]

update [dbo].[data_kladr_20210706]
set
	 latitude = convert(float,[data_kladr_upd].latitude)
	,longitude = convert(float,[data_kladr_upd].longitude)
	--,[address] = [data_kladr_upd].[address]
from [dbo].[data_kladr_upd_1] as [data_kladr_upd]
where
	[data_kladr_upd].[kladr] = [data_kladr_20210706].[OwnerKLADRCode]
	and [data_kladr_20210706].latitude is null

update [dbo].[data_kladr_20210706]
set
	 latitude = convert(float,[data_kladr_upd].latitude)
	,longitude = convert(float,[data_kladr_upd].longitude)
	--,[address] = [data_kladr_upd].[address]
from [dbo].[data_kladr_upd_2] as [data_kladr_upd]
where
	[data_kladr_upd].[kladr] = [data_kladr_20210706].[OwnerKLADRCode]
	and [data_kladr_20210706].latitude is null

update [dbo].[data_kladr_20210706]
set
	-- latitude = convert(float,[data_kladr_upd].latitude)
	--,longitude = convert(float,[data_kladr_upd].longitude)
	 [address] = [data_kladr_upd].[address]
from [dbo].[data_kladr_upd_3] as [data_kladr_upd]
where
	[data_kladr_upd].[kladr] = [data_kladr_20210706].[OwnerKLADRCode]

update [dbo].[data_kladr_20210706]
set
	 latitude = convert(float,[data_kladr_upd].latitude)
	,longitude = convert(float,[data_kladr_upd].longitude)
	--,[address] = [data_kladr_upd].[address]
from [dbo].[data_kladr_upd_4] as [data_kladr_upd]
where
	[data_kladr_upd].[kladr] = [data_kladr_20210706].[OwnerKLADRCode]
	and [data_kladr_20210706].latitude is null

update [dbo].[data_kladr_20210706]
set
	 latitude = convert(float,[data_kladr_upd].latitude)
	,longitude = convert(float,[data_kladr_upd].longitude)
	--,[address] = [data_kladr_upd].[address]
from [dbo].[data_kladr_upd_5] as [data_kladr_upd]
where
	[data_kladr_upd].[kladr] = [data_kladr_20210706].[OwnerKLADRCode]
	and [data_kladr_20210706].latitude is null

/*
select [OwnerKLADRCode]
--into dbo.data_kladr_1
FROM [dbo].[data_kladr_20210706]
where [latitude] is null
*/

---------------------------------

drop table [dbo].[data_kladr_kladr_20210706]

select
	 k1.[date]

	,k1.[OwnerKLADRCode] as [OwnerKLADRCode]
	,k1.[count_pol] as count_pol_1
	,k1.[premium] as premium_1
	,k1.[count_pol_with_claim] as count_pol_with_claim_1
	,k1.[claim_count] as claim_count_1
	,k1.[claim_sum] as claim_sunm_1
	,k1.[paid_sum] as paid_sum_1
	,k1.[claim_sum_infl] as claim_sum_infl_1
	,k1.[paid_sum_infl] as paid_sum_infl_1
	,k1.[latitude] as latitude_1
	,k1.[longitude] as longitude_1

	,k2.[OwnerKLADRCode] as kladr_2
	,k2.[count_pol] as count_pol_2
	,k2.[premium] as premium_2
	,k2.[count_pol_with_claim] as count_pol_with_claim_2
	,k2.[claim_count] as claim_count_2
	,k2.[claim_sum] as claim_sum_2
	,k2.[paid_sum] as paid_sum_2
	,k2.[claim_sum_infl] as claim_sum_infl_2
	,k2.[paid_sum_infl] as paid_sum_infl_2
	,k2.[latitude] as latitude_2
	,k2.[longitude] as longitude_2

	,[dbo].[geo_dist]( k1.[latitude], k1.[longitude], k2.[latitude], k2.[longitude] ) as dist


into [dbo].[data_kladr_kladr_20210706]

from
	[dbo].[data_kladr_20210706] as k1

	left join [dbo].[data_kladr_20210706] as k2
		on
			k2.[latitude] between k1.[latitude] - 6 and k1.[latitude] + 6
			and k2.[longitude] between k1.[longitude] - 6/COS(k1.[latitude]*PI()/180) and  k1.[longitude] + 6/COS(k1.[latitude]*PI()/180)

---------------------------------

update [dbo].[data_kladr_20210706]
set
	 count_pol_200 = T.count_pol
	,premium_200 = T.premium
	,count_pol_with_claim_200 = T.count_pol_with_claim
	,claim_count_200 = T.claim_count
	--,claim_count_adj_200 = T.claim_count_adj
	,claim_sum_200 = T.claim_sum
	,paid_sum_200 = T.paid_sum
	,claim_sum_infl_200 = T.claim_sum_infl
	,paid_sum_infl_200 = T.paid_sum_infl
from
	(
		select
			 [OwnerKLADRCode]
			,sum([data_kladr_kladr_20210706].count_pol_2) as count_pol
			,sum([data_kladr_kladr_20210706].premium_2) as premium
			,sum([data_kladr_kladr_20210706].count_pol_with_claim_2) as count_pol_with_claim
			,sum([data_kladr_kladr_20210706].claim_count_2) as claim_count
			--,sum([data_kladr_kladr_20210706].claim_count_adj_2) as claim_count_adj
			,sum([data_kladr_kladr_20210706].claim_sum_2) as claim_sum
			,sum([data_kladr_kladr_20210706].paid_sum_2) as paid_sum
			,sum([data_kladr_kladr_20210706].claim_sum_infl_2) as claim_sum_infl
			,sum([data_kladr_kladr_20210706].paid_sum_infl_2) as paid_sum_infl
		from [dbo].[data_kladr_kladr_20210706]
		where isnull(dist,10000) <= 200
		group by [OwnerKLADRCode]
	) as T
where T.[OwnerKLADRCode] = [data_kladr_20210706].[OwnerKLADRCode]

update [dbo].[data_kladr_20210706]
set
	 count_pol_500 = T.count_pol
	,premium_500 = T.premium
	,count_pol_with_claim_500 = T.count_pol_with_claim
	,claim_count_500 = T.claim_count
	--,claim_count_adj_500 = T.claim_count_adj
	,claim_sum_500 = T.claim_sum
	,paid_sum_500 = T.paid_sum
	,claim_sum_infl_500 = T.claim_sum_infl
	,paid_sum_infl_500 = T.paid_sum_infl
from
	(
		select
			 [OwnerKLADRCode]
			,sum([data_kladr_kladr_20210706].count_pol_2) as count_pol
			,sum([data_kladr_kladr_20210706].premium_2) as premium
			,sum([data_kladr_kladr_20210706].count_pol_with_claim_2) as count_pol_with_claim
			,sum([data_kladr_kladr_20210706].claim_count_2) as claim_count
			--,sum([data_kladr_kladr_20210706].claim_count_adj_2) as claim_count_adj
			,sum([data_kladr_kladr_20210706].claim_sum_2) as claim_sum
			,sum([data_kladr_kladr_20210706].paid_sum_2) as paid_sum
			,sum([data_kladr_kladr_20210706].claim_sum_infl_2) as claim_sum_infl
			,sum([data_kladr_kladr_20210706].paid_sum_infl_2) as paid_sum_infl
		from [dbo].[data_kladr_kladr_20210706]
		where isnull(dist,10000) <= 500
		group by [OwnerKLADRCode]
	) as T
where T.[OwnerKLADRCode] = [data_kladr_20210706].[OwnerKLADRCode]

---------------------------------
/*
alter table [dbo].[data_osago]
add
	 latitude float
	,longitude float
*/

update [dbo].[data_osago]
set
	 latitude = [data_kladr_20210706].latitude
	,longitude = [data_kladr_20210706].longitude
from [dbo].[data_kladr_20210706]
where [data_osago].[OwnerKLADRCode] = [data_kladr_20210706].[OwnerKLADRCode]

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
	 count_pol_200 = [data_kladr_20210706].count_pol_200
	,count_pol_with_claim_200 = [data_kladr_20210706].count_pol_with_claim_200
	,claim_count_200 = [data_kladr_20210706].claim_count_200
	,claim_count_adj_200 = [data_kladr_20210706].claim_count_adj_200
	,claim_sum_200 = [data_kladr_20210706].claim_sum_200
	,paid_sum_200 = [data_kladr_20210706].paid_sum_200
	,claim_sum_infl_200 = [data_kladr_20210706].claim_sum_infl_200
	,paid_sum_infl_200 = [data_kladr_20210706].paid_sum_infl_200

	,count_pol_500 = [data_kladr_20210706].count_pol_500
	,count_pol_with_claim_500 = [data_kladr_20210706].count_pol_with_claim_500
	,claim_count_500 = [data_kladr_20210706].claim_count_500
	,claim_count_adj_500 = [data_kladr_20210706].claim_count_adj_500
	,claim_sum_500 = [data_kladr_20210706].claim_sum_500
	,paid_sum_500 = [data_kladr_20210706].paid_sum_500
	,claim_sum_infl_500 = [data_kladr_20210706].claim_sum_infl_500
	,paid_sum_infl_500 = [data_kladr_20210706].paid_sum_infl_500

from [dbo].[data_kladr_20210706]
where [data_osago].[OwnerKLADRCode] = [data_kladr_20210706].[OwnerKLADRCode]

---------------------------------
/*
alter table [dbo].[data_osago_claims]
add
	 latitude float
	,longitude float
*/

update [dbo].[data_osago_claims]
set
	 latitude = [data_kladr_20210706].latitude
	,longitude = [data_kladr_20210706].longitude
from [dbo].[data_kladr_20210706]
where [data_osago_claims].[OwnerKLADRCode] = [data_kladr_20210706].[OwnerKLADRCode]

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
	 count_pol_200 = [data_kladr_20210706].count_pol_200
	,count_pol_with_claim_200 = [data_kladr_20210706].count_pol_with_claim_200
	,claim_count_200 = [data_kladr_20210706].claim_count_200
	,claim_count_adj_200 = [data_kladr_20210706].claim_count_adj_200
	,claim_sum_200 = [data_kladr_20210706].claim_sum_200
	,paid_sum_200 = [data_kladr_20210706].paid_sum_200
	,claim_sum_infl_200 = [data_kladr_20210706].claim_sum_infl_200
	,paid_sum_infl_200 = [data_kladr_20210706].paid_sum_infl_200

	,count_pol_500 = [data_kladr_20210706].count_pol_500
	,count_pol_with_claim_500 = [data_kladr_20210706].count_pol_with_claim_500
	,claim_count_500 = [data_kladr_20210706].claim_count_500
	,claim_count_adj_500 = [data_kladr_20210706].claim_count_adj_500
	,claim_sum_500 = [data_kladr_20210706].claim_sum_500
	,paid_sum_500 = [data_kladr_20210706].paid_sum_500
	,claim_sum_infl_500 = [data_kladr_20210706].claim_sum_infl_500
	,paid_sum_infl_500 = [data_kladr_20210706].paid_sum_infl_500

from [dbo].[data_kladr_20210706]
where [data_osago_claims].[OwnerKLADRCode] = [data_kladr_20210706].[OwnerKLADRCode]

---------------------------------
/*
alter table [dbo].[DB_Quotes]
add
	 latitude float
	,longitude float
*/

update [dbo].[DB_Quotes]
set
	 latitude = [data_kladr_20210706].latitude
	,longitude = [data_kladr_20210706].longitude
from [dbo].[data_kladr_20210706]
where [DB_Quotes].[OwnerKLADRCode] = [data_kladr_20210706].[OwnerKLADRCode]

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
	 count_pol_200 = [data_kladr_20210706].count_pol_200
	,count_pol_with_claim_200 = [data_kladr_20210706].count_pol_with_claim_200
	,claim_count_200 = [data_kladr_20210706].claim_count_200
	,claim_count_adj_200 = [data_kladr_20210706].claim_count_adj_200
	,claim_sum_200 = [data_kladr_20210706].claim_sum_200
	,paid_sum_200 = [data_kladr_20210706].paid_sum_200
	,claim_sum_infl_200 = [data_kladr_20210706].claim_sum_infl_200
	,paid_sum_infl_200 = [data_kladr_20210706].paid_sum_infl_200

	,count_pol_500 = [data_kladr_20210706].count_pol_500
	,count_pol_with_claim_500 = [data_kladr_20210706].count_pol_with_claim_500
	,claim_count_500 = [data_kladr_20210706].claim_count_500
	,claim_count_adj_500 = [data_kladr_20210706].claim_count_adj_500
	,claim_sum_500 = [data_kladr_20210706].claim_sum_500
	,paid_sum_500 = [data_kladr_20210706].paid_sum_500
	,claim_sum_infl_500 = [data_kladr_20210706].claim_sum_infl_500
	,paid_sum_infl_500 = [data_kladr_20210706].paid_sum_infl_500

from [dbo].[data_kladr_20210706]
where
	[DB_Quotes].[OwnerKLADRCode] = [data_kladr_20210706].[OwnerKLADRCode]
	and [DB_Quotes].[count_pol_200] is null

---------------------------------

drop table [dbo].[data_cities]
drop table [dbo].[data_kladr_cities]

select
	 avg([longitude]) as [longitude]
	,avg([latitude]) as [latitude]
	,replace(replace([region],'�','�'),'�','�') as [region]
	,replace(replace([name],'�','�'),'�','�') as [name]
	,max(isnull([population],0)) as [population]
into [dbo].[data_cities]
from [dbo].[data_cities_upd]
group by
	 [region]
	,[name]

select
	 k1.[date]

	,k1.[OwnerKLADRCode] as kladr_1
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
	[dbo].[data_kladr_20210706] as k1
	left join [dbo].[data_cities] as c
		on
			c.[latitude] between k1.[latitude] - 6 and k1.[latitude] + 6
			and c.[longitude] between k1.[longitude] - 6/COS(k1.[latitude]*PI()/180) and  k1.[longitude] + 6/COS(k1.[latitude]*PI()/180)

update [dbo].[data_kladr_20210706]
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
where T.[kladr_1] = [data_kladr_20210706].[OwnerKLADRCode]

/*
alter table [dbo].[data_osago]
add
	 population_200 float
*/

update [dbo].[data_osago]
set
	 population_200 = [data_kladr_20210706].population_200
from [dbo].[data_kladr_20210706]
where [data_osago].[OwnerKLADRCode] = [data_kladr_20210706].[OwnerKLADRCode]

/*
alter table [dbo].[data_osago_claims]
add
	 population_200 float
*/

update [dbo].[data_osago_claims]
set
	 population_200 = [data_kladr_20210706].population_200
from [dbo].[data_kladr_20210706]
where [data_osago_claims].[insurerKLADR] = [data_kladr_20210706].[OwnerKLADRCode]

/*
alter table [dbo].[DB_Quotes]
add
	 population_200 float
*/

update [dbo].[DB_Quotes]
set
	 population_200 = [data_kladr_20210706].population_200
from [dbo].[data_kladr_20210706]
where
	[DB_Quotes].[OwnerKLADRCode] = [data_kladr_20210706].[OwnerKLADRCode]
	and [DB_Quotes].population_200 is null

---------------------------------
-- ������� � {

drop table [dbo].[data_kladr_city]

select

	 k1.[date]
	,k1.[OwnerKLADRCode] as [OwnerKLADRCode]
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

	,k2.[��� ����] as Code_FIAS
	,k2.[������� ������ ������ ��� �������] as Feature_district_center
	,k2.[���������] as Population_district
	,k2.[����������� �����] as Federal_district

	,[dbo].[geo_dist]( k1.[latitude], k1.[longitude], k2.������, k2.������� ) as dist
	
into [dbo].[data_kladr_city]

from
	[dbo].[data_kladr_20210706] as k1
	left join [dbo].City_district as k2
		on
			k2.������ between k1.[latitude] - 6 and k1.[latitude] + 6
			and k2.������� between k1.[longitude] - 6/COS(k1.[latitude]*PI()/180) and  k1.[longitude] + 6/COS(k1.[latitude]*PI()/180)

update data_kladr

	set District_city_dist = isnull(f.dist, 100)

	from data_kladr as k 

	left join 
	(
	select top_feature.*, c.dist from (
	select [OwnerKLADRCode], case when Feature_district_center = 3 then 2 else Feature_district_center end as Feature_district_center, max(Population_district) as m_Population_district from [data_kladr_city]
	where dist <= 200
	group by [OwnerKLADRCode], case when Feature_district_center = 3 then 2 else Feature_district_center end ) as top_feature

	left join [data_kladr_city] as c
	on top_feature.m_Population_district = c.Population_district
		and top_feature.[OwnerKLADRCode] = c.[OwnerKLADRCode]
		and top_feature.Feature_district_center = c.Feature_district_center ) as f

	on k.[OwnerKLADRCode] = f.[OwnerKLADRCode]

	where Feature_district_center = 1
	
update data_kladr

	set Area_city_dist = isnull(f.dist, 200)

	from data_kladr as k 

	left join 
	(
	select top_feature.*, c.dist from (
	select [OwnerKLADRCode], case when Feature_district_center = 3 then 2 else Feature_district_center end as Feature_district_center, max(Population_district) as m_Population_district from [data_kladr_city]
	where dist <= 200
	group by [OwnerKLADRCode], case when Feature_district_center = 3 then 2 else Feature_district_center end ) as top_feature

	left join [data_kladr_city] as c
	on top_feature.m_Population_district = c.Population_district
	and top_feature.[OwnerKLADRCode] = c.[OwnerKLADRCode]
	and top_feature.Feature_district_center = c.Feature_district_center ) as f
	on k.[OwnerKLADRCode] = f.[OwnerKLADRCode]

	where Feature_district_center = 2
	

	
/*
alter table [dbo].[data_kladr_20210706]
add
	 Population_district float
*/

update data_kladr

	set Population_district = isnull(f.Population_district, 300000)

	from data_kladr as k 

	left join 
	(select distinct insurerKLADR, Population_district from data_kladr_city) as f

	on k.[OwnerKLADRCode] = f.[OwnerKLADRCode]

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
	on c.[OwnerKLADRCode] = d.[OwnerKLADRCode]

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
	on c.OwnerKLADRCode = d.[OwnerKLADRCode]

/*
alter table [dbo].data_osago
add
	 Population_Area_city float
	,District_city_dist float
	,Area_city_dist float
	,Population_District_city float
	
*/

update data_osago
	
set District_city_dist = isnull(d.District_city_dist, 101),
		Area_city_dist = isnull(d.Area_city_dist, 201)

	from data_osago as c

	left join data_kladr as d
	on c.[OwnerKLADRCode] = d.[OwnerKLADRCode] 


update data_osago
	
set Population_District_city = isnull(d.m_Population_district, 100000)

	from data_osago as c

	left join (
select s.[OwnerKLADRCode], s.dist, cast(replace(replace( s.m_Population_district, ']', ''), '[', '' ) as int) as m_Population_district from (
            select top_feature.*, c.dist from (
            select [OwnerKLADRCode], case when Feature_district_center = 3 then 2 else Feature_district_center end as Feature_district_center, max(Population_district) as m_Population_district from [data_kladr_city]
            where dist <= 200
            group by [OwnerKLADRCode], case when Feature_district_center = 3 then 2 else Feature_district_center end ) as top_feature
            left join [data_kladr_city] as c
            on top_feature.m_Population_district = c.Population_district
                and top_feature.[OwnerKLADRCode] = c.[OwnerKLADRCode]
                and top_feature.Feature_district_center = c.Feature_district_center ) as s) as d
	on c.insurerKLADR = d.[OwnerKLADRCode] 

update DB_Quotes
	
set Population_District_city = isnull(d.m_Population_district, 100000)

	from DB_Quotes as c

	left join (
select s.[OwnerKLADRCode], s.dist, cast(replace(replace( s.m_Population_district, ']', ''), '[', '' ) as int) as m_Population_district from (
            select top_feature.*, c.dist from (
            select [OwnerKLADRCode], case when Feature_district_center = 3 then 2 else Feature_district_center end as Feature_district_center, max(Population_district) as m_Population_district from [data_kladr_city]
            where dist <= 200
            group by [OwnerKLADRCode], case when Feature_district_center = 3 then 2 else Feature_district_center end ) as top_feature
            left join [data_kladr_city] as c
            on top_feature.m_Population_district = c.Population_district
                and top_feature.[OwnerKLADRCode] = c.[OwnerKLADRCode]
                and top_feature.Feature_district_center = c.Feature_district_center ) as s) as d
	on c.OwnerKLADRCode = d.[OwnerKLADRCode] 

update data_osago_claims
	
set Population_District_city = isnull(d.m_Population_district, 100000)

	from data_osago_claims as c

	left join (
select s.[OwnerKLADRCode], s.dist, cast(replace(replace( s.m_Population_district, ']', ''), '[', '' ) as int) as m_Population_district from (
            select top_feature.*, c.dist from (
            select [OwnerKLADRCode], case when Feature_district_center = 3 then 2 else Feature_district_center end as Feature_district_center, max(Population_district) as m_Population_district
			 from [data_kladr_city]
            where dist <= 200
            group by [OwnerKLADRCode], case when Feature_district_center = 3 then 2 else Feature_district_center end ) as top_feature
            left join [data_kladr_city] as c
            on top_feature.m_Population_district = c.Population_district
                and top_feature.[OwnerKLADRCode] = c.[OwnerKLADRCode]
                and top_feature.Feature_district_center = c.Feature_district_center ) as s) as d
	on c.insurerKLADR = d.[OwnerKLADRCode] 
	
update data_osago
	
set Population_Area_city = isnull(a.m_Population_district, 1000000)

	from data_osago as c
	left join [dbo].[area_table] as a
	on c.[OwnerKLADRCode] = a.[OwnerKLADRCode]
	
update data_osago_claims
	
set Population_Area_city = isnull(a.m_Population_district, 1000000)

	from data_osago_claims as c
	left join [dbo].[area_table] as a
	on c.[OwnerKLADRCode] = a.[OwnerKLADRCode]

update DB_Quotes
	
set Population_Area_city = isnull(a.m_Population_district, 1000000)

	from DB_Quotes as c
	left join [dbo].[area_table] as a
	on c.OwnerKLADRCode = a.[OwnerKLADRCode]


/*
alter table [dbo].data_osago
add
	 Population_density_Subject float
	,Population_density_FO float
	,Population_Subject float
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
	on left(c.[OwnerKLADRCode], 2) = a.Code_district

/*
alter table [dbo].data_osago_claims
add
	 Population_density_Subject float
	,Population_density_FO float
	,Population_Subject float
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
	on left(c.[OwnerKLADRCode], 2) = a.Code_district
		
/*
alter table [dbo].DB_Quotes
add
	 Population_density_Subject float
	,Population_density_FO float
	,Population_Subject float
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
*/

update data_osago_claims 
	
	set IsCity = isnull(f.isCity, 0)
	
	from data_osago_claims as q
	left join
	(SELECT 1 as isCity, code FROM [Scoring_OSAGO_TEST].[dbo].[KLADR_CDI] where [SOCR] = '�') as f
	on q.[OwnerKLADRCode] = f.CODE

/*
alter table [dbo].data_osago
add
	IsCity float
*/

update data_osago 
	
	set IsCity = isnull(f.isCity, 0)
	
	from data_osago as q
	left join
	(SELECT 1 as isCity, code FROM [Scoring_OSAGO_TEST].[dbo].[KLADR_CDI] where [SOCR] = '�') as f
	on q.insurerKLADR = f.CODE

/*
alter table [dbo].DB_Quotes
add
	IsCity float
*/

update DB_Quotes 
	
	set IsCity = isnull(f.isCity, 0)
	
	from DB_Quotes as q
	left join
	(SELECT 1 as isCity, code FROM [Scoring_OSAGO_TEST].[dbo].[KLADR_CDI] where [SOCR] = '�') as f
	on q.OwnerKLADRCode = f.CODE


-- ������� � }
---------------------------------



			
