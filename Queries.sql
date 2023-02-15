Q1
SELECT * FROM Tenancy_History
SELECT profile_id,first_name+' '+last_name AS Full_Name , phone From Profiles
WHERE profile_id= (SELECT TOP 1 profile_id FROM Tenancy_History ORDER BY DATEDIFF(dd, Move_In_Date, Move_Out_Date))

Q2

SELECT first_name+' '+last_name AS Full_Name , phone, email_id From Profiles
WHERE (profile_id IN (SELECT profile_id
 FROM Profiles WHERE marital_status = 'Y' ) or profile_id IN
                (   SELECT profile_id FROM Tenancy_History WHERE rent> '9000'));
Q3

SELECT p.profile_id, first_name+' '+last_name AS Full_Name , p.phone, p.email_id,p.city, t.house_id, t.rent,t.Move_In_Date,t.Move_Out_Date,
e.latest_employer,e.occupational_category, r.profile_id, COUNT(r.profile_id) AS Total_count
FROM Profiles p
RIGHT JOIN
Tenancy_History t
ON
p.profile_id = t.profile_id
RIGHT JOIN
Employment_Details e
ON
p.profile_id=e.profile_id
RIGHT JOIN
Referral r
ON
e.profile_id=r.profile_id
WHERE r.profile_id IS NOT NULL
GROUP BY p.profile_id ,p.first_name,p.last_name, p.phone, p.email_id,p.city, t.house_id, t.rent,t.Move_In_Date,t.Move_Out_Date,
e.latest_employer,e.occupational_category, r.profile_id
HAVING p.city = 'Bangalore' OR p.city = 'Pune'







Q4

SELECT p.first_name+' '+p.last_name AS Full_Name ,p.email_id,p.phone,p.referral_code, SUM(r.referrer_bonus_amount) 
as Total_bonus_amount, r.referral_valid
FROM Profiles p
JOIN
Referral r
ON
p.profile_id = r.profile_id

GROUP BY p.first_name,p.last_name,p.email_id,p.phone,p.referral_code,r.referral_valid
HAVING (SUM(r.referral_valid)>=1)




Q5
SELECT Profiles.city , SUM(Tenancy_History.rent) AS Rent_Generated
FROM
Profiles 
JOIN
Tenancy_History 
ON
Profiles.profile_id = Tenancy_History.profile_id
GROUP_BY Profiles.city 
UNION
SELECT 'Total',  SUM(rent) FROM Tenancy_History



Q6

CREATE VIEW vw_tenant AS
SELECT p.profile_id,t.rent,t.move_in_date,h.house_type,h.beds_vacant,a.description ,p.city, a.description AS address
FROM Profiles p
JOIN
Tenancy_History t
ON p.profile_id = t.profile_id
JOIN
Houses h
ON h.house_id = t.house_id
JOIN
Addresses a
ON a.house_id = t.house_id
 WHERE move_in_date>='2015-04-30' 
AND move_out_date IS NULL and
h.beds_vacant>0

SELECT * FROM vw_tenant
Q7

SELECT profile_id, valid_till, DATEADD (MONTH, 1, valid_till) as New_Valid_Date
FROM Referral r
WHERE exists ( SELECT profile_id, count(profile_id) AS COUNT
FROM Referral 
GROUP BY profile_id
HAVING count(profile_id)>2 )
group by r.profile_id, r.valid_till
Q8

SELECT Profiles.profile_id,first_name+' '+last_name AS Full_Name , phone,
iif( rent > 10000 ,' A' ,iif ( rent < 7500 ,' C','B')) AS Customer_segment
FROM
Profiles
Join
Tenancy_History 
On
Profiles.profile_id = Tenancy_History.profile_id

Q9

SELECT p.first_name+' '+p.last_name AS Full_Name , p.phone,p.city,h.house_type, 
h.bhk_type,h.bed_count,h.beds_vacant,h.furnishing_type
FROM Profiles p 
LEFT JOIN
Tenancy_History t
ON 
t.profile_id=p.profile_id
LEFT JOIN Houses h
ON 
t.house_id=h.house_id
WHERE p.profile_id not in (SELECT profile_id FROM Referral);
Q10

SELECT * , (bed_count - beds_vacant) AS Total_Occupancy
FROM Houses
ORDER BY Total_Occupancy DESC

