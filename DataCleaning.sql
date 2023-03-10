/****** Script for SelectTopNRows command from SSMS  ******/
---------------------------------sale date-------------------------------------------------
SELECT 
       [SaleDate],
	   SaleDateConverted
FROM [SqlTutorial].[dbo].[Housing];

ALTER TABLE [SqlTutorial].[dbo].[Housing]
ADD SaleDateConverted date;

UPDATE [SqlTutorial].[dbo].[Housing]
SET SaleDateConverted = convert(date,SaleDate);
---------------------------------Proprety Address-------------------------------------------------
SELECT 
     a.ParcelID,
	 b.ParcelID,
	 a.PropertyAddress,
	 b.PropertyAddress,
	 isnull(a.PropertyAddress,b.PropertyAddress) 
FROM [SqlTutorial].[dbo].[Housing] a
JOIN [SqlTutorial].[dbo].[Housing] b
ON a.ParcelID= b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null;


UPDATE a
SET PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
FROM [SqlTutorial].[dbo].[Housing] a
JOIN [SqlTutorial].[dbo].[Housing] b
ON a.ParcelID= b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null;
---------------------------------substring/charindex-------------------------------------------------
SELECT 
     *
FROM [SqlTutorial].[dbo].[Housing];

SELECT 
	 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as address,
	 SUBSTRING(PropertyAddress,(CHARINDEX(',',PropertyAddress)+1),LEN(PropertyAddress)) as city
FROM [SqlTutorial].[dbo].[Housing];


ALTER TABLE [SqlTutorial].[dbo].[Housing]
ADD PropertyAddressSplit varchar(255),
	ProperSplitCity varchar(255); 

UPDATE [SqlTutorial].[dbo].[Housing]
--SET PropertyAddressSplit=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
SET ProperSplitCity=SUBSTRING(PropertyAddress,(CHARINDEX(',',PropertyAddress)+1),LEN(PropertyAddress))

---------------------------------substring/charindex Owner Address-------------------------------------------------
SELECT 
     *
FROM [SqlTutorial].[dbo].[Housing];

SELECT 
	 --SUBSTRING(c,1,CHARINDEX(',',OwnerAddress)-1)as address,
	-- SUBSTRING(OwnerAddress,(CHARINDEX(',',OwnerAddress)+1),LEN(OwnerAddress)) as city
	OwnerAddress,
	 PARSENAME(OwnerAddressCity,3),
	 PARSENAME(REPLACE(OwnerAddressCity,',','.') ,2),
	 PARSENAME(REPLACE(OwnerAddressCity,',','.') ,1)
FROM [SqlTutorial].[dbo].[Housing];

ALTER TABLE [SqlTutorial].[dbo].[Housing]
ADD OwnerSplitState varchar(255),
-- OwnerAddressCity varchar(255); 

UPDATE [SqlTutorial].[dbo].[Housing]
SET OwnerAddressSplit=SUBSTRING(OwnerAddress,1,CHARINDEX(',',OwnerAddress)-1)
SET OwnerAddressCity=SUBSTRING(OwnerAddress,(CHARINDEX(',',OwnerAddress)+1),LEN(OwnerAddress));
---------------------------------UPDATE VS CASE STATEMENT-------------------------------------------------
SELECT
	--*
	 DISTINCT SoldAsVacant,COUNT(SoldAsVacant),
	 CASE WHEN SoldAsVacant='Y' THEN 'Yes'
	      WHEN SoldAsVacant ='N' THEN 'No'
		  ELSE SoldAsVacant
	 END 
FROM [SqlTutorial].[dbo].[Housing]
GROUP BY SoldAsVacant

UPDATE [SqlTutorial].[dbo].[Housing]
SET SoldAsVacant=
	 CASE WHEN SoldAsVacant='Y' THEN 'Yes'
	      WHEN SoldAsVacant ='N' THEN 'No'
		  ELSE SoldAsVacant
	 END 
---------------------------------IDENTIFY DUPLICATES-----------------------------------------
--Partition on unique things
WITH CTE AS(
SELECT
*,
ROW_NUMBER()OVER(PARTITION BY ParcelID,PropertyAddress, SalePrice,SaleDate,LegalReference 
ORDER BY UniqueID) AS RN
FROM [SqlTutorial].[dbo].[Housing])

SELECT
* FROM CTE WHERE RN>1;

--DELETE
--FROM CTE WHERE RN>1;



------------------------------------DROP COLUMNS------------------------------------------
SELECT
    *
FROM [SqlTutorial].[dbo].[Housing] 

ALTER TABLE [SqlTutorial].[dbo].[Housing]
DROP column PropertyAddress,OwnerAddress,TaxDistrict
ALTER TABLE [SqlTutorial].[dbo].[Housing]
DROP column SaleDate
-------------------------------------------------------------------------------------------