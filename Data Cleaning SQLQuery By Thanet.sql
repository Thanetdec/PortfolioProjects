--**** Data cleaning ****--

Select *
from NashvilleHousing

-------------

-- standardize Date format

Select saleDateconverted, Convert(date,saledate)
from NashvilleHousing

Update NashvilleHousing
set saledate = Convert(date,saledate)

Alter table NashvilleHousing
Add Saledateconverted Date;

Update NashvilleHousing
set Saledateconverted = Convert(date,saledate)

-------------------------------------

-- Populate Property Address data

Select *
from NashvilleHousing
--where propertyaddress is null
order by parcelid

Select a.Parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
from NashvilleHousing a
JOIN NashvilleHousing b
	on a.Parcelid = b.Parcelid
	AND A.[Uniqueid] <> b.[UniqueID]
where a.propertyaddress is null

update a
set propertyaddress = isnull(a.propertyaddress, b.propertyaddress)
from NashvilleHousing a
JOIN NashvilleHousing b
	on a.Parcelid = b.Parcelid
	AND A.[Uniqueid] <> b.[UniqueID]
where a.propertyaddress is null

------------------------------
--Breaking out address into individual column (address, City, State)

Select Propertyaddress
from NashvilleHousing

Select
SUBSTRING(Propertyaddress, 1, CHARINDEX(',',Propertyaddress) -1 ) as Address,
SUBSTRING(Propertyaddress, CHARINDEX(',',Propertyaddress) +1 , LEN(Propertyaddress)) as Address

from NashvilleHousing

ALTER TABLE NashvilleHousing
Add Propertysplitaddress Nvarchar(255);

Update NashvilleHousing
Set	Propertysplitaddress = CONVERT(date,saledate)

ALTER TABLE NashvilleHousing
Add PropertysplitCity Nvarchar(255);

Update NashvilleHousing
Set	PropertysplitCity = CONVERT(date,saledate)

Select *
from NashvilleHousing


Select Owneraddress
from NashvilleHousing

Select
PARSENAME(replace(owneraddress, ',', '.'), 3)
,PARSENAME(replace(owneraddress, ',', '.'), 2)
,PARSENAME(replace(owneraddress, ',', '.'), 1)
from NashvilleHousing

ALTER TABLE NashvilleHousing
Add Ownersplitaddress Nvarchar(255);

Update NashvilleHousing
Set	Ownersplitaddress = PARSENAME(replace(owneraddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnersplitCity Nvarchar(255);

Update NashvilleHousing
Set	OwnersplitCity = PARSENAME(replace(owneraddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add Ownersplitstate Nvarchar(255);

Update NashvilleHousing
Set	Ownersplitstate = PARSENAME(replace(owneraddress, ',', '.'), 1)

Select *
From NashvilleHousing


--------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct(soldasvacant), Count(soldasvacant)
from NashvilleHousing
Group by soldasvacant
order by 2



Select soldasvacant
, CASE When soldasvacant = 'Y'
Then 'Yes'
When soldasvacant = 'N' Then 'No'
else soldasvacant
END
from NashvilleHousing

Update NashvilleHousing
set	soldasvacant = CASE When soldasvacant = 'Y'
Then 'Yes'
When soldasvacant = 'N' Then 'No'
else soldasvacant
END

--------------------------------

-- Remove duplicates

WITH RownumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY Parcelid, Propertyaddress, Saleprice, saledate, LegalReference
            ORDER BY Uniqueid
        ) AS row_num
    FROM NashvilleHousing
)
Select *
FROM RownumCTE
WHERE row_num > 1
ORDER BY Propertyaddress;

-----------------------------------

-- Delete unused Column

Select *
From NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, Propertyaddress

ALTER TABLE NashvilleHousing
DROP COLUMN Saledate

