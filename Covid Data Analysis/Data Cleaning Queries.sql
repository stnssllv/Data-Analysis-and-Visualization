/* Queries for Data Cleaning */
--USE [Data Cleaning];

--View Data--
SELECT * FROM [Data Cleaning]..HousingData ORDER BY 2;

--Change Date Format--
ALTER TABLE [Data Cleaning]..HousingData ADD SaleDateConv DATE;
UPDATE [Data Cleaning]..HousingData SET SaleDateConv = CONVERT(DATE, SaleDate);

--Replace NULL in PropertyAddress with the data for the same ParcelID--
SELECT p1.ParcelID, p1.PropertyAddress, p2.ParcelID, p2.PropertyAddress, ISNULL(p1.PropertyAddress, p2.PropertyAddress)
FROM [Data Cleaning]..HousingData p1 JOIN [Data Cleaning]..HousingData p2 ON p1.ParcelID = p2.ParcelID AND p1.UniqueID != p2.UniqueID
WHERE p1.PropertyAddress IS NULL;

UPDATE p1
SET PropertyAddress = ISNULL(p1.PropertyAddress, p2.PropertyAddress)
FROM [Data Cleaning]..HousingData p1 JOIN [Data Cleaning]..HousingData p2 ON p1.ParcelID = p2.ParcelID AND p1.UniqueID != p2.UniqueID
WHERE p1.PropertyAddress IS NULL;


--Split the Address into columns--
--PropertyAddress--
SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM [Data Cleaning]..HousingData;

ALTER TABLE [Data Cleaning]..HousingData ADD PropAddress VARCHAR(255);
ALTER TABLE [Data Cleaning]..HousingData ADD PropCity VARCHAR(255);

UPDATE [Data Cleaning]..HousingData SET PropAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);
UPDATE [Data Cleaning]..HousingData SET PropCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));


--OwnerAddress--
SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3), PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2), PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [Data Cleaning]..HousingData;

ALTER TABLE [Data Cleaning]..HousingData ADD OwnAddress VARCHAR(255);
ALTER TABLE [Data Cleaning]..HousingData ADD OwnCity VARCHAR(255);
ALTER TABLE [Data Cleaning]..HousingData ADD OwnState VARCHAR(255);

UPDATE [Data Cleaning]..HousingData SET OwnAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);
UPDATE [Data Cleaning]..HousingData SET OwnCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);
UPDATE [Data Cleaning]..HousingData SET OwnState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


--Change Y to Yes and N to No in SoldAsVacant--
UPDATE [Data Cleaning]..HousingData SET SoldAsVacant = CASE 
							WHEN SoldAsVacant = 'Y' THEN 'Yes' 
							WHEN SoldAsVacant = 'N' THEN 'No' 
							ELSE SoldAsVacant END


--Remove Duplicate Rows--
WITH RowNumberCTE AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY UniqueID) AS RowNumber
FROM [Data Cleaning]..HousingData)

DELETE FROM RowNumberCTE WHERE RowNumber > 1;


----------------------------
--Remove Changed Columns--
ALTER TABLE [Data Cleaning]..HousingData DROP COLUMN PropertyAddress, SaleDate, OwnerAddress;