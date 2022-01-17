SELECT						
	--DISTINCT sa.id "ServiceAppointment ID",					
	--s.order_id "Order Id",					
	--s.pk "Shipment ID",					
	--s.short_shipment_id "Short Shipment Id",					
	DISTINCT wo.id "WorkOrder ID",					
	wo.status "WorkOrder Status",					
	--sa.status "Appointment Status",					
	--concat(concat('http://www.onepeloton.com/delivery/',s.order_id),'/reschedule') "Rescheduler Link",					
	--o.shipping_addressee_first_name,					
	--o.shipping_phone_number "phone",					
	--o.email "email",					
	TO_CHAR(DATE_TRUNC('day',CONVERT_TIMEZONE('UTC', oh.timezone,WO.createddate)), 'YYYY-MM-DD') "Order Date ET",					
	--sa.toplevelterritoryname__c "FSL Warehouse",					
	st.name "Zone",					
	--st.description "Fulfillment Warehouse Slug",					
	wt.name "Work Type",					
	--sa.order_to_scheduled_delivery__c "Current OTD",					
	TO_CHAR(DATE_TRUNC('day',CONVERT_TIMEZONE('UTC',oh.timezone,sa.arrivalwindowstarttime)), 'YYYY-MM-DD') "Current Scheduled Date",					
	--sa.schedstarttime "scheduled datetime UTC",					
	--TO_CHAR(DATE_TRUNC('week',sa.schedstarttime), 'YYYY-MM-DD') AS "Current Fiscal Week",					
	---------b.name,					
	--skrq.skillid "Skill Requirement",					
	--sk.masterlabel "Skill Name",					
	--skrq.id,					
	--skrq1.skillid "WT Skill ID",					
	--sk1.masterlabel "WT Skill Name",					
	--s.short_shipment_id "Short Shipment Id",					
	oh.timezone "time zone",					
	--wo.number_of_forced_reschedules__c "Reschedule Count"					
	wo.WorkOrder_TopLevelTerritoryName__c					
	--'Jan 29, 2021' AS "New Date",					
	--TO_CHAR(DATE_TRUNC('hour',CONVERT_TIMEZONE('UTC',oh.timezone,sa.arrivalwindowstarttime)), 'hh:00 am') "Window Start",					
	--TO_CHAR(DATE_TRUNC('hour',CONVERT_TIMEZONE('UTC',oh.timezone,sa.arrivalwindowendtime)), 'hh:00 am') "Window End"					
FROM ods_ecomm_hourly.shipment s						
						
	RIGHT JOIN					
		sd_salesforce2_fieldservice.serviceappointment sa ON s.partner_work_order_id = sa.parentrecordid				
	--RIGHT JOIN 					
		--sd_salesforce2_fieldservice.serviceresource sr ON sa.service_resource_name__c = sr.name				
	INNER JOIN 					
		sd_salesforce2_fieldservice.serviceterritory st ON sa.serviceterritoryid = st.id				
	--  INNER JOIN 					
		--sd_salesforce2_fieldservice.serviceterritory pt ON pt.id =				
	LEFT JOIN 					
		sd_salesforce2.workorder wo ON wo.id = sa.parentrecordid				
	INNER JOIN 					
		sd_salesforce2_fieldservice.worktype wt ON sa.worktypeid = wt.id				
	LEFT JOIN 					
		sd_salesforce2_fieldservice.workorderlineitem woli ON woli.workorderid = wo.id				
	--LEFT JOIN 					
		--ods_ecomm_hourly.peloton_order o ON s.order_id = o.pk			-- OLD sd2_ecomm_realtime.peloton_order o ON s.order_id = o.pk	
	INNER JOIN 					
		sd_salesforce2_fieldservice.operatinghours oh ON st.operatinghoursid = oh.id				
	--LEFT JOIN 					
		--sd2_ecomm_realtime.orderitem oi ON woli.reference_id__c = oi.pk				
	--LEFT JOIN 					
		--ods_ecomm_daily.bundleoption bo ON oi.bundle_option_id = bo.pk			-- OLD prod_postgres_ecomm.bundleoption bo ON oi.bundle_option_id = bo.pk	
	--LEFT JOIN 					
		--ods_ecomm_daily.bundle b ON  bo.bundle_id= b.pk			-- OLD prod_postgres_ecomm.bundle b ON  bo.bundle_id= b.pk	
	--INNER JOIN 					
		--sd_salesforce2_fieldservice.skillrequirement skrq ON skrq.relatedrecordid = wo.id				
	--INNER JOIN 					
		--sd_salesforce2_fieldservice.skill sk ON sk.id = skrq.skillid				
	--INNER JOIN 					
		--sd_salesforce2_fieldservice.skillrequirement skrq1 ON skrq1.relatedrecordid = wt.id				
	--INNER JOIN 					
		--sd_salesforce2_fieldservice.skill sk1 ON sk1.id = skrq1.skillid				
WHERE 						
	wo.status NOT IN ('Canceled','Cancelled')					
		--AND sa.status IN ('Scheduled','Dispatched')				
		--AND sa.countrycode IN ('US','CA')				
		AND CONVERT_TIMEZONE('UTC', oh.timezone ,WO.createddate) >= (timestamp '2021-07-14')				
		AND wo.WorkOrder_TopLevelTerritoryName__c IN (				
		Chicago',				
		Cincinnati - Dayton',				
		Cleveland - Brooklyn Heights',				
		Detroit - Southfield',				
		Minneapolis',				
		Pittsburgh - Cranberry Township',				
		St. Louis - Hazelwood',				
		Toronto - Vaughan',				
		Chicago - Waukegan')				
		--AND CONVERT_TIMEZONE('UTC', 'America/New_York',sa.schedstarttime) < (timestamp '2021-02-01')				
		--AND "Current Fiscal Week" IN ('2020-12-21')				
		--AND wt.name = 'Bike Plus Delivery'				
		--AND wo.number_of_forced_reschedules__c >= 1				
		--AND sk.masterlabel IN ('Undefined','Bike Van','Tread Van','Bike Plus Capacity Reschedule', 'Tread Plus Capacity Reschedule', 'Bike Capacity Reschedule')				
		--AND oi.name NOT LIKE '%Refurb%'				
		--AND b.name IS NOT NULL				
		--AND LEFT(wo.id,15) IN ()				
		--AND wo.id IN ()				
