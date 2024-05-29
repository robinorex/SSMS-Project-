select * from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1]
--Standardize Date format
select SaleDate,convert(date,SaleDate) from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1]
Alter table [Nashville Housing Data for Data Cleaning 1] add saledateconverted Date;
Update [Nashville Housing Data for Data Cleaning 1] set saledateconverted=convert(date,SaleDate)
--Populate Property Address Data
select * from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1]
--where PropertyAddress is null
order by ParcelID
--isnull(if a is null, use b to fill in)
select a.ParcelID,a.PropertyAddress ,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] a
join [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] b
on a.ParcelID=b.ParcelID
and a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null

update a  --use alias
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] a
join [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] b
on a.ParcelID=b.ParcelID
and a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null
--Breaking out Address into individual columns
select PropertyAddress from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1]
--substring(column,start position,end position) use LEN(column) means at the end of the position
select substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City  
from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1]

Alter table [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] add PropertySplitAddress Nvarchar(255);
Update [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] set PropertySplitAddress=substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] add PropertySplitCity Nvarchar(255);
Update [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
select*from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1]

select Parsename(replace(OwnerAddress,',','.'),3) as Owner_Street,
PARSENAME(replace(OwnerAddress,',','.'),2) as Owner_City,
PARSENAME(replace(OwnerAddress,',','.'),1) as Owner_State
from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1]

Alter table [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] add OwnerSplitAddress Nvarchar(255);
Update [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] set OwnerSplitAddress=Parsename(replace(OwnerAddress,',','.'),3)
Alter table [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] add OwnerSplitCity Nvarchar(255);
Update [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] set OwnerSplitCity=PARSENAME(replace(OwnerAddress,',','.'),2)
Alter table [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] add OwnerSplitState Nvarchar(255);
select* from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1]

--change Y and N to Yes or No
select distinct(SoldAsVacant1),count(SoldAsVacant)  from
[SQL tutorial]..[Nashville Housing Data for Data Cleaning 1]
group by SoldAsVacant1
order by 2

select SoldAsVacant, CASE when SoldAsVacant = '1' THEN 'YES' when SoldAsVacant='0' then 'NO' end as SoldAsVacant1 from
[SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] 
Alter table [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] add SoldAsVacant1 Nvarchar(255);
update [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] SET
SoldAsVacant1= CASE when SoldAsVacant = '1' THEN 'YES' when SoldAsVacant='0' then 'NO' end

--remove duplicates CTE
with RowNumCTE AS(
select *, ROW_NUMBER() OVER(partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference ORDER by UniqueID) as row_num
from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] 
) Delete from RowNumCTE where row_num >1 
with RowNumCTE AS(
select *, ROW_NUMBER() OVER(partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference ORDER by UniqueID) as row_num
from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] 
) select * from RowNumCTE where row_num >1 

--delete unused columns
select * from [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] 
Alter table [SQL tutorial]..[Nashville Housing Data for Data Cleaning 1] 
drop column SoldAsVacant, OwnerAddress,TaxDistrict,PropertyAddress