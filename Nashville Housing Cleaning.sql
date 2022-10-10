Select *
From [Portfolio Project].dbo.NashvilleHousing


--Standardize Date Format

Select SaleDate, CONVERT(Date, SaleDate)
From [Portfolio Project].dbo.NashvilleHousing

UPDATE NashvilleHousing
Set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted, CONVERT(Date, SaleDate)
From [Portfolio Project].dbo.NashvilleHousing

--Populate Property Address Data


Select *
From [Portfolio Project].dbo.NashvilleHousing
order by ParcelID


Select alpha.ParcelID, alpha.PropertyAddress, beta.ParcelID, beta.PropertyAddress, ISNULL(alpha.PropertyAddress, beta.PropertyAddress )
From [Portfolio Project].dbo.NashvilleHousing alpha
JOIN [Portfolio Project].dbo.NashvilleHousing beta
	on alpha.ParcelID = beta.ParcelID
	AND alpha.[UniqueID ] <> beta.[UniqueID ]
Where alpha.PropertyAddress is null

UPDATE alpha 
SET PropertyAddress = ISNULL(alpha.PropertyAddress, beta.PropertyAddress )
From [Portfolio Project].dbo.NashvilleHousing alpha
JOIN [Portfolio Project].dbo.NashvilleHousing beta
	on alpha.ParcelID = beta.ParcelID
	AND alpha.[UniqueID ] <> beta.[UniqueID ]
Where alpha.PropertyAddress is null


--Dividing Address into separate columns (Address, City, State)


Select PropertyAddress
From [Portfolio Project].dbo.NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress)) as City
From [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add Prop_Split_Add NVARCHAR(255);

UPDATE NashvilleHousing
SET Prop_Split_Add = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add Prop_Split_City NVARCHAR(255);

UPDATE NashvilleHousing
SET Prop_Split_City = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress))

--Updated Table
Select *
From [Portfolio Project].dbo.NashvilleHousing

--Now Using the Owner's Address

Select OwnerAddress
From [Portfolio Project].dbo.NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',' , '.' ),3)
,PARSENAME(REPLACE(OwnerAddress,',' , '.' ),2)
,PARSENAME(REPLACE(OwnerAddress,',' , '.' ),1)
From [Portfolio Project].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add Owner_Split_Add NVARCHAR(255);

UPDATE NashvilleHousing
SET Owner_Split_Add = PARSENAME(REPLACE(OwnerAddress,',' , '.' ),3)

ALTER TABLE NashvilleHousing
Add Owner_Split_City NVARCHAR(255);

UPDATE NashvilleHousing
SET Owner_Split_City = PARSENAME(REPLACE(OwnerAddress,',' , '.' ),2)

ALTER TABLE NashvilleHousing
Add Owner_Split_State NVARCHAR(255);

UPDATE NashvilleHousing
SET Owner_Split_State = PARSENAME(REPLACE(OwnerAddress,',' , '.' ),1)


--Updated Table
Select *
From [Portfolio Project].dbo.NashvilleHousing

--Change Y and N to yes and No
--FInding what is more common 
Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From [Portfolio Project].dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
,Case When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End
From [Portfolio Project].dbo.NashvilleHousing

UPDATE NashvilleHousing
Set SoldAsVacant = Case 
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End

--Remove Duplicates

With RowNumCTE as(
Select *,
	ROW_NUMBER() Over(
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 Order By
					UniqueID
					)row_num

From [Portfolio Project].dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num >1 
Order by PropertyAddress


Select *
From [Portfolio Project].dbo.NashvilleHousing

--Deleting Unused Columns

Select *
From [Portfolio Project].dbo.NashvilleHousing

Alter Table [Portfolio Project].dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress