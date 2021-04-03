create table if not exists regions(
	region text primary key
);
create table if not exists areas(
	name text primary key
);
create table if not exists teritories(
	name text primary key
);
create table if not exists Addresses(
	id serial primary key,
	reg_name text,
	area_name text,
	ter_name text,
	CONSTRAINT fk_address_region
      FOREIGN KEY(reg_name) 
	  REFERENCES regions(region),
	CONSTRAINT fk_address_area
      FOREIGN KEY(area_name) 
	  REFERENCES areas(name),
	CONSTRAINT fk_address_ter
      FOREIGN KEY(ter_name) 
	  REFERENCES teritories(name)
);
create table if not exists OrganizationTypes(
	name text primary key
);
create table if not exists OrganizationParents(
	name text primary key
);
create table if not exists Organizations(
	name text primary key,
	typeName text,
	parent text,
	address_id int,
	CONSTRAINT fk_organization_type
      FOREIGN KEY(typeName) 
	  REFERENCES OrganizationTypes(name),
	CONSTRAINT fk_organization_adddress
      FOREIGN KEY(address_id) 
	  REFERENCES Addresses(id),
	CONSTRAINT fk_organization_parents
      FOREIGN KEY(parent) 
	  REFERENCES OrganizationParents(name)
);
create table if not exists BirthDates(
	BirthYear int4,
	primary key(BirthYear)
);
create table if not exists Sex(
	sex_type text,
	primary key(sex_type)
);
create table if not exists TerTypeNames(
	type_name text,
	primary key(type_name)
);
create table if not exists ClassProfileNames(
	name text,
	primary key(name)
);
create table if not exists ClassLangNames(
	name text,
	primary key(name)
);
create table if not exists Subjects(
	name text,
	primary key(name)
);
create table if not exists Languages(
	name text primary key
);
CREATE TABLE if not exists Students (
    OUTID uuid,
    BirthYear int4,
    Sex text,
    TerTypeName text,
    ClassProfileName text,
    ClassLangName text,
    Study_place text,
    Birth_address_id int,
    primary key (OUTID),
    CONSTRAINT fk_birth_date
      FOREIGN KEY(BirthYear) 
	  REFERENCES BirthDates(BirthYear), 
	CONSTRAINT fk_person_sex
      FOREIGN KEY(Sex) 
	  REFERENCES Sex(sex_type) ,
	CONSTRAINT fk_person_ter_type
      FOREIGN KEY(TerTypeName) 
	  REFERENCES TerTypeNames(type_name) ,
	CONSTRAINT fk_person_class_profile_name
      FOREIGN KEY(ClassProfileName) 
	  REFERENCES ClassProfileNames(name) ,
	CONSTRAINT fk_person_class_language
	  FOREIGN KEY(ClassLangName) 
	  REFERENCES ClassLangNames(name),
	CONSTRAINT fk_person_study_organization
	  FOREIGN KEY(Study_place) 
	  REFERENCES Organizations(name),
	CONSTRAINT fk_person_birth_address
	  FOREIGN KEY(Birth_address_id) 
	  REFERENCES Addresses(id)
);
create table if not exists Exam(
	id SERIAL primary KEY,
	Person uuid,
	Ball100 int4,
	Ball12 int2,
	Ball int2,
	AdaptScale text,
	DpaLevel text,
	Subject text,
	Status text,
	Language text,
	Exam_year int4,
	Exam_organization text,
	constraint fk_exam_subject_name
		FOREIGN KEY(Subject) 
	  	REFERENCES Subjects(name),
	constraint fk_exam_laguage
		FOREIGN KEY(Language) 
	  	REFERENCES Languages(name),
	constraint fk_exam_organization
		FOREIGN KEY(Exam_organization) 
	  	REFERENCES Organizations(name),
	constraint fk_exam_person
		FOREIGN KEY(Person) 
	  	REFERENCES Students(OUTID) 
);