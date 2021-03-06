--CREATE DATABASE skillsmonster;

--CREATE TABLE skill (id SERIAL NOT NULL CONSTRAINT skill_id_pk PRIMARY KEY,name VARCHAR(200),code VARCHAR(50),key_skill BOOLEAN,collection_id INTEGER);
--CREATE UNIQUE INDEX skill_id_uindex ON skill (id);
--CREATE TABLE vacancy (raw_data JSONB,search_request_id INTEGER,id VARCHAR(100) NOT NULL CONSTRAINT vacancies_list_id_pk UNIQUE);
--CREATE UNIQUE INDEX vacancies_list_id_uindex ON vacancy (id);

--CREATE TABLE search_result (id SERIAL NOT NULL CONSTRAINT search_result_pkey PRIMARY KEY,search_reauest_id INTEGER,raw_response JSONB,page INTEGER);
--CREATE UNIQUE INDEX search_result_id_uindex ON search_result (id);
--CREATE INDEX search_result__index ON search_result (((raw_response ->> 'found' :: TEXT) :: INTEGER));
--CREATE TABLE search_request (id SERIAL NOT NULL CONSTRAINT search_request_pkey PRIMARY KEY,period_from TIMESTAMP,industry VARCHAR(100),source_site_id INTEGER,area INTEGER,per_page INTEGER,found INTEGER,raw_request VARCHAR(500),period_to TIMESTAMP,date_time TIMESTAMP,pages INTEGER);
--CREATE UNIQUE INDEX search_request_id_uindex ON search_request (id);
--COMMENT ON TABLE search_request IS 'о';
--ALTER TABLE vacancy ADD CONSTRAINT vacancies_list_search_request_id_fk FOREIGN KEY (search_request_id) REFERENCES search_request;
--ALTER TABLE search_result ADD CONSTRAINT search_result_search_request_id_fk FOREIGN KEY (search_request_id) REFERENCES search_request;
--CREATE TABLE source_site (id SERIAL NOT NULL CONSTRAINT source_site_pkey PRIMARY KEY,name VARCHAR(100),url VARCHAR(500),api_url VARCHAR(500));
--CREATE UNIQUE INDEX source_site_id_uindex ON source_site (id);
--ALTER TABLE search_request ADD CONSTRAINT search_request_source_site_id_fk FOREIGN KEY (source_site_id) REFERENCES source_site;
--CREATE TABLE country (alpha_2 VARCHAR(2),short_name VARCHAR(200),full_name VARCHAR(500),alpha_3 VARCHAR(3) NOT NULL CONSTRAINT country_pkey PRIMARY KEY,num_code INTEGER);
--CREATE UNIQUE INDEX country_alpha_3_uindex ON country (alpha_3);
--CREATE TABLE area(id SERIAL NOT NULL CONSTRAINT area_pkey PRIMARY KEY,country VARCHAR(3) CONSTRAINT area_country_alpha_3_fk REFERENCES country,name VARCHAR(500),type VARCHAR(20),code VARCHAR(100),zip VARCHAR(100),ext_code VARCHAR(100));
--CREATE UNIQUE INDEX area_id_uindex ON area (id);
--ALTER TABLE search_request ADD CONSTRAINT search_request_area_id_fk FOREIGN KEY (area_id) REFERENCES area;
--CREATE TABLE industry(id SERIAL NOT NULL CONSTRAINT industry_pkey PRIMARY KEY,code VARCHAR(100) NOT NULL);
--CREATE UNIQUE INDEX industry_id_uindex ON industry (id);
--CREATE UNIQUE INDEX industry_code_uindex ON industry (code);
--ALTER TABLE search_request ADD CONSTRAINT search_request_industry_code_fk FOREIGN KEY (industry_id) REFERENCES industry (code);

CREATE FUNCTION is_vacancy_loaded(vac_id CHARACTER VARYING) RETURNS BOOLEAN LANGUAGE SQL AS $$SELECT exists(SELECT 1 FROM remove_vacancy WHERE id = vac_id)$$;

CREATE VIEW vacancy_to_load AS SELECT i.id,i.name,i.created_at,(i.employer -> 'name' :: TEXT) AS emp_name,(i.address -> 'city' :: TEXT) AS emp_city,(i.salary -> 'to' :: TEXT) AS salary_to FROM (search_result sr CROSS JOIN LATERAL jsonb_to_recordset((sr.raw_response #> '{items}' :: TEXT [])) i(id TEXT,name TEXT,url TEXT,created_at TIMESTAMP WITHOUT TIME ZONE,employer JSONB,address JSONB,salary JSONB)) WHERE (is_vacancy_loaded((i.id) :: CHARACTER VARYING) IS FALSE);
CREATE VIEW all_vacancies AS SELECT i.id,i.name,i.created_at,(i.employer -> 'name' :: TEXT) AS emp_name,(i.address -> 'city' :: TEXT) AS emp_city,(i.salary -> 'to' :: TEXT) AS salary_to FROM (search_result sr CROSS JOIN LATERAL jsonb_to_recordset((sr.raw_response #> '{items}' :: TEXT [])) i(id TEXT,name TEXT,url TEXT,created_at TIMESTAMP WITHOUT TIME ZONE,employer JSONB,address JSONB,salary JSONB));
CREATE VIEW key_skills AS SELECT vl.id,i.name FROM (remove_vacancy vl CROSS JOIN LATERAL jsonb_to_recordset((vl.raw_data #> '{key_skills}' :: TEXT [])) i(name TEXT));
CREATE VIEW all_key_skills AS SELECT i.name,count(i.name) AS count FROM (remove_vacancy vl CROSS JOIN LATERAL jsonb_to_recordset((vl.raw_data #> '{key_skills}' :: TEXT [])) i(name TEXT)) GROUP BY i.name ORDER BY (count(i.name)) DESC;
CREATE VIEW all_key_skills_by_date AS SELECT ((vl.raw_data ->> 'published_at' :: TEXT)) :: TIMESTAMP WITH TIME ZONE AS published,i.name,count(*) AS count FROM (remove_vacancy vl CROSS JOIN LATERAL jsonb_to_recordset((vl.raw_data #> '{key_skills}' :: TEXT [])) i(name TEXT)) GROUP BY ((vl.raw_data ->> 'published_at' :: TEXT)) :: TIMESTAMP WITH TIME ZONE,i.name;
CREATE VIEW vacancy_to_load_hh AS SELECT i.id,i.name,i.created_at,(i.employer -> 'name'::text) AS emp_name,(i.address -> 'city'::text) AS emp_city,(i.salary -> 'to'::text) AS salary_to FROM (search_result sr CROSS JOIN LATERAL jsonb_to_recordset((sr.raw_response #> '{items}'::text[])) i(id text, name text, url text, created_at timestamp without time zone, employer jsonb, address jsonb, salary jsonb)) WHERE (NOT (i.id IN ( SELECT (remove_vacancy.id)::text AS id FROM remove_vacancy)));


INSERT INTO public.source_site (id,name,url,api_url) VALUES (1,'HeadHunter','https://www.hh.ru','https://api.hh.ru/');
INSERT INTO public.country (alpha_2,short_name,full_name,alpha_3,num_code) VALUES ('US','United States','Unites States of America','USA',840);
INSERT INTO public.country (alpha_2,short_name,full_name,alpha_3,num_code) VALUES ('RU','Russia','Russian Federation','RUS',640);
INSERT INTO public.area (id,country_code,name,type,code,zip,ext_code) VALUES (1,'RUS','Moscow','REG','77','101000','1');
INSERT INTO public.industry (id,code) VALUES (1,'7');
INSERT INTO public.industry (id,code) VALUES (2,'7.540');
INSERT INTO public.industry (id,code) VALUES (3,'7.541');
INSERT INTO public.industry (id,code) VALUES (4,'7.538');
INSERT INTO public.industry (id,code) VALUES (5,'7.539');