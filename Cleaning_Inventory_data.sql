##check data##

Select * 
from inv_data

##Delete not neccesary column##
##Clening process##

ALTER TABLE inv_data
DROP COLUMN Sales_UOM, Pricing_Unit, Revenue_Account

ALTER TABLE inv_data
DROP COLUMN [Bin Location Remark], [Fixed Assets], 
[Part Group], [Part Type], [Date of Last Reval# Price]

ALTER TABLE inv_data
DROP COLUMN [Revenue Account - Foreign], [Asset Class], [Item Cost],
[Last Evaluated Price], [Currency of Fixed Commission],
[Inactive from], [Inactive]

ALTER TABLE inv_data
DROP COLUMN [no], [Bin Location Shelf]


##Recheck table##

SELECT *
FROM inv_data
WHERE In_stock IS NOT NULL AND In_stock <> 0;

SELECT t1.*
FROM inv_data t1
JOIN inv_data t2 ON t1.item_no = t2.item_no
WHERE t1.[Item Group] = 'ENG Inventory' AND t1.In_Stock <> 0 AND t2.item_no LIKE 'E%';













