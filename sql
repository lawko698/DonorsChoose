CREATE DATABASE DONORS_CHOOSE;


CREATE TABLE donations(
	project_id	VARCHAR(200) NOT NULL,
	donation_id VARCHAR(200) PRIMARY KEY,
	donor_id VARCHAR(200) NOT NULL,
	donation_included_optional_donation VARCHAR(3) NOT NULL,
	donation_amount numeric(10,2) NOT NULL,
	donor_cart_sequence integer NOT NULL,
	donation_receieved_date TIMESTAMP NOT NULL
);

CREATE TABLE projects(
	project_id	VARCHAR(200) PRIMARY KEY,
	school_id VARCHAR(200) NOT NULL,
	teacher_id VARCHAR(200) NOT NULL,
	teacher_project_posted_sequence integer NOT NULL,
	project_type VARCHAR(200),
	project_subject_category_tree VARCHAR(200),
	project_subject_subcategory_tree VARCHAR(200),
	project_grade_level_category VARCHAR(200),
	project_resource_category VARCHAR(200),
	project_cost numeric(10,2) NOT NULL,	
	project_posted_date DATE,
	project_expiration_date DATE,
	project_current_status VARCHAR(200),
	project_fully_funded_date DATE
);

CREATE TABLE schools(
	school_id VARCHAR(200) PRIMARY KEY,
	school_name VARCHAR(200),
	school_metro_type VARCHAR(200),
	school_percentage_free_lunch numeric(4,1),
	school_state VARCHAR(200),
	school_zip integer,
	school_city VARCHAR(200),
	school_county VARCHAR(200),
	school_district VARCHAR(200)
);


select date_trunc( 'year', donation_receieved_date ) as date_year, school_state as us_state, 
(CASE 
WHEN project_subject_category_tree LIKE 'Applied Learning%' THEN 'Applied Learning'
WHEN project_subject_category_tree LIKE 'Literacy & Language%' THEN 'Literacy & Language' 
WHEN project_subject_category_tree LIKE 'History & Civics%' THEN 'History & Civics' 
WHEN project_subject_category_tree LIKE 'Music & The Arts%' THEN 'Music & The Arts' 
WHEN project_subject_category_tree LIKE 'Math & Science%' THEN 'Math & Science'
WHEN project_subject_category_tree LIKE 'Special Needs%' THEN 'Special Needs'
WHEN project_subject_category_tree LIKE 'Health & Sports%' THEN 'Health & Sports'
WHEN project_subject_category_tree LIKE 'Warmth, Care & Hunger%' THEN 'Warmth, Care & Hunger'
END) as project_category,school_metro_type as school_type, sum(donation_amount) as project_amount, count(distinct d.project_id) as num_projects, project_current_status as project_status, project_resource_category as project_resource 
from donations d 
join projects p on d.project_id = p.project_id 
join schools s on p.school_id = s.school_id
where school_metro_type not in ('unknown')
and project_subject_category_tree is not NULL
and to_char(donation_receieved_date, 'YYYY' ) != '2018'
and project_resource_category is not NULL
group by school_state, school_metro_type, project_subject_category_tree, date_trunc( 'year', donation_receieved_date ), project_current_status, project_resource_category