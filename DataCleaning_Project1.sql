create database PROJECT1
use PROJECT1
select top(100) *  from  sheet1


/* 
     cleaning data in SQL QUERIES
*/

select * from sheet1;

-- STANDARDIZE DATE FORMAT
/*
 Here we standardize the date format using function "convert" and datatype "date" and we will create a new column as "SaleDateConverted"
 */
select SaleDate, CONVERT (DATE,SaleDate)
	 from sheet1;
update sheet1
	set SaleDate = convert(date, SaleDate)    /*  it didn't change in that column so i created a new column named "saleDateConverted"  */
ALTER TABLE sheet1
	add SaleDateConverted Date;
update sheet1                                        /*   here i updated the new column SaleDateConverted wih Changed date values.   */
	set SaleDateConverted = convert(date, SaleDate)
select SaleDateConverted from sheet1;
-------------------------------------------------------------------------------------------------------

--POPULATE PROPER ADDRESS DATA

select*									/* here we check for null values in Property Address*/
from sheet1 
where PropertyAddress is null
order by parcelid;

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , isnull(a.PropertyAddress, B.PropertyAddress)  
from sheet1 a join sheet1 b						/* here we check for null values having same parcel id and diff unique id inorder differentitate b/w same parcel id's*/
on a.parcelid=b.parcelid						/* " ISNULL " built in function is used to replace the null value with some value*/
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a                            /* here we updated the column a.PropertyAddress using the above query by fetching and changing the null values */     
SET PropertyAddress = isnull(a.PropertyAddress, B.PropertyAddress)
from sheet1 a join sheet1 b 
on a.parcelid=b.parcelid
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null;

-----------------------------------------------------------------------------------------------------------------------------------------------------
--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS(Address, City, State)

select PropertyAddress				
from sheet1 
--where PropertyAddress is null
--order by parcelid;

select								/* here we break a column into separate coulmns using substring charindex and len functions*/
SUBSTRING(PropertyAddress, 1 ,charindex(',' ,PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as Address
from sheet1

alter table sheet1						/* here we create a new column " PropertySplitAddress " */
  add PropertySplitAddress nvarchar(222);
 
update sheet1							/* here we update the changed/new values into the new column */
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1 ,charindex(',' ,PropertyAddress)-1) 

alter table sheet1						/* here we create a new column " PropertySplitCity " */
add PropertySplitCity nvarchar(222);

update sheet1							/* here we update the changed/new values into the new column */
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))

select * from sheet1;

select OwnerAddress from sheet1;   /* here we split the OwnerAddress but in a simple way using PARSE_NAME function
									   here we use replace function because PARASE_FUNCTION works only with period(.) but we have comma(,) so to replace it we use replace function */
select 
PARSENAME(replace(OwnerAddress,',','.'),3),		/* here we should give index as 3 to retrieve first value in PARSE_NAME function */
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)		/* here we should give index as 1 to retrieve last value in PARSE_NAME function */

from sheet1


alter table sheet1								/* here we create a new column " OwnerSplitAddress " */
add OwnerSplitAddress nvarchar(222);

update sheet1									/* here we update the changed/new values into the new column */
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3);

alter table sheet1								/* here we create a new column " OwnerSplitCity " */
add OwnerSplitCity nvarchar(222);

update sheet1									/* here we update the changed/new values into the new column */
set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2);

alter table sheet1								/* here we create a new column " OwnerSplitState " */
add OwnerSplitState nvarchar(222);

update sheet1									/* here we update the changed/new values into the new column */
set ownerSplitState =  PARSENAME(replace(OwnerAddress,',','.'),1);

select * from sheet1;

-------------------------------------------------------------------------------------------------------------

--CHANGE Y AND N TO YES AND NO IN "Sold as Vacant" field 

select distinct(SoldAsVacant) 
from sheet1;

select distinct(SoldAsVacant),count(SoldAsVacant) as total_count /*  here we chweck for distinct values and their count in SoldAsVacant column  */
from sheet1
group by SoldAsVacant
order by total_count;



select SoldAsVacant   /* here we change shortforms i.e "Y" and "N" into "YES" and "NO" i.e normal form by using case statements  */
, case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
 from sheet1; 

 update sheet1     /* here we update the changed/new values into the Exisiting column */
 set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from sheet1;

select distinct(SoldAsVacant) from sheet1;

------------------------------------------------------------------------------------------------------------

--Remove Duplicates        /* here We remove the duplicate values using function delete */ 
							/* to  check and find the duplicate rows we use functions like ROW_NUMBER , OVER, PARTITION by and CTE */									
with RowNumCTE as(				/* "partition by" clause is used always inside "over clause" */
select *,							/* the "partition by"  formed by parttition clause is called as "WINDOW" inorder to call a window we should use CTE */
 ROW_NUMBER() over(				/* Specifies a temporary named result set, known as a "common table expression (CTE) "*/
 partition by Parcelid,
              PropertyAddress,
			  Saleprice,
			  Saledate,
			  LegalReference
			  order by
			       uniqueid
			  ) row_num
 from sheet1
 )
 delete  
 from RowNumCTE
 where row_num >1
 --order by PropertyAddress

 -------------------------------------------------------------------------

 --DELETE UNUSED COLUMNS     /* here we delete unused columns by dropping the columns using alter function */

 ALTER TABLE SHEET1				/* if we need to drop any column we shouldn't do in raw data for sure*/
 DROP COLUMN SaleDate,OwnerAddress, Taxdistrict, PropertyAddress

 
 ALTER TABLE SHEET1
 DROP COLUMN SaleDate
 select * from sheet1; 