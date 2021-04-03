insert into areas(name)
select distinct areaname from zno_persons zp
on conflict do nothing;

insert into regions(region)
select distinct regname from zno_persons zp
on conflict do nothing;

insert into teritories(name)
select distinct tername from zno_persons zp
on conflict do nothing;

insert into birthdates(birthyear)
select distinct zp.birth from zno_persons zp
on conflict do nothing;

insert into sex
select distinct zp.sextypename from zno_persons zp
on conflict do nothing;

insert into tertypenames 
select distinct zp.tertypename from zno_persons zp
on conflict do nothing;

insert into classprofilenames 
select distinct
	case
		when zp.classprofilename is NULL then 'Невідомо'
		else zp.classprofilename
	end
from zno_persons zp
on conflict do nothing;

insert into classprofilenames 
select distinct
	case
		when zp.classprofilename is NULL then 'Невідомо'
		else zp.classprofilename
	end
from zno_persons zp
on conflict do nothing;

insert into classlangnames 
select distinct
	case
		when zp.classlangname is NULL then 'Невідомо'
		else zp.classlangname
	end
from zno_persons zp
on conflict do nothing;

insert into regions 
select distinct
	case
		when zp.regname is NULL then 'Невідомо'
		else zp.regname
	end
from zno_persons zp
on conflict do nothing;

insert into teritories 
select distinct
	case
		when zp.tername is NULL then 'Невідомо'
		else zp.tername
	end
from zno_persons zp
on conflict do nothing;

insert into areas 
select distinct
	case
		when zp.areaname is NULL then 'Невідомо'
		else zp.areaname
	end
from zno_persons zp
on conflict do nothing;

INSERT INTO public.addresses (reg_name, area_name, ter_name)
select distinct regname, areaname, tername from zno_persons;

insert into organizationtypes 
select distinct
	case
		when zp.eotypename is NULL then 'Невідомо'
		else zp.eotypename
	end
from zno_persons zp
on conflict do nothing;

insert into organizationparents 
select distinct
	case
		when zp.eoparent is NULL then 'Невідомо'
		else zp.eoparent
	end
from zno_persons zp
on conflict do nothing;

INSERT INTO public.organizations (name, typename, parent, address_id)
select distinct on (eoname)
case
		when eoname is NULL then 'КПІ'
		else eoname
end,
eotypename,
eoparent , 
(select id from addresses 
where reg_name = eoregname
and area_name = eoareaname
and ter_name = eotername limit 1) from zno_persons 
order by eoname,eoparent desc nulls first;


INSERT INTO public.students (outid, birthyear, sex, tertypename, classprofilename, classlangname, study_place, birth_address_id) 
select outid, birth, sextypename, tertypename, classprofilename, classlangname,
(select name from organizations as o1
where o1.name = z1.eoname limit 1),
(select id
from addresses as a1 
where a1.area_name  = z1.areaname
and a1.reg_name = z1.regname
and a1.ter_name = z1.tername limit 1) from zno_persons as z1;

INSERT INTO public.subjects
values
('Українська мова і література')
,('Історія України')
,('Математика')
,('Фізика')
,('Хімія')
,('Географія')
,('Французька мова')
,('Німецька мова')
,('Іспанська мова')
,('Біологія')
,('Англійська мова');


INSERT INTO public.exam (person, exam_year, subject, status, ball100, ball12, ball, adaptscale, exam_organization)
select 
outid, year, ukrtest, ukrteststatus, ukrball100, ukrball12, ukrball, ukradaptscale,
case 
 when (select count(*) from organizations
 		where name = ukrptname) = 0
 		then null
 else ukrptname
end
from zno_persons as z1
where ukrtest notnull;

insert into languages 
select distinct
	case
		when zp.histlang is NULL then 'Невідомо'
		else zp.histlang
	end
from zno_persons zp

union all

select distinct
	case
		when zp.mathlang is NULL then 'Невідомо'
		else zp.mathlang
	end
from zno_persons zp

union all

select distinct
	case
		when zp.physlang is NULL then 'Невідомо'
		else zp.physlang
	end
from zno_persons zp

on conflict do nothing;

INSERT INTO public.exam (person, exam_year, subject,"language", status, ball100, ball12, ball, adaptscale, exam_organization)
select 
outid, year, histtest, histlang, histteststatus, histball100, histball12, histball, null,
case 
 when (select count(*) from organizations
 		where name = histptname) = 0
 		then null
 else histptname
end
from zno_persons as z1
where histtest notnull ;

INSERT INTO public.exam (person, exam_year, subject,"language", status, ball100, ball12, ball, adaptscale, exam_organization)
select 
outid, year, mathtest, mathlang, mathteststatus, mathball100, mathball12, mathball,null,
case 
 when (select count(*) from organizations
 		where name = mathptname) = 0
 		then null
 else mathptname
end
from zno_persons as z1
where mathtest notnull;

INSERT INTO public.exam (person, exam_year, subject,"language", status, ball100, ball12, ball, adaptscale, exam_organization)
select 
outid , year, phystest, physlang, physteststatus, physball100, physball12, physball,null,
case 
 when (select count(*) from organizations
 		where name = physptname) = 0
 		then null
 else physptname
end
from zno_persons as z1
where phystest notnull;

INSERT INTO public.exam (person, exam_year, subject,"language", status, ball100, ball12, ball, exam_organization)
select 
outid, year, chemtest, chemlang, chemteststatus, chemball100, chemball12, chemball,
case 
 when (select count(*) from organizations
 		where name = chemptname) = 0
 		then null
 else chemptname
end
from zno_persons as z1
where chemtest notnull;

INSERT INTO public.exam (person, exam_year, subject,"language", status, ball100, ball12, ball, exam_organization)
select distinct 
outid, year, biotest, biolang, bioteststatus, bioball100, bioball12, bioball,
case 
 when (select count(*) from organizations
 		where name = bioptname) = 0
 		then null
 else bioptname
end
from zno_persons as z1
where biotest notnull;

INSERT INTO public.exam (person, exam_year, subject,"language", status, ball100, ball12, ball, exam_organization)
select distinct
outid, year, geotest, geolang, geoteststatus, geoball100, geoball12, geoball,
case 
 when (select count(*) from organizations
 		where name = geoptname) = 0
 		then null
 else geoptname
end
from zno_persons as z1
where geotest notnull;

INSERT INTO public.exam (person, exam_year, subject, status, ball100, ball12,dpalevel, ball, exam_organization)
select distinct
outid, year, engtest, engteststatus, engball100, engball12, engdpalevel, engball,
case 
 when (select count(*) from organizations
 		where name = engptname) = 0
 		then null
 else engptname
end
from zno_persons as z1
where engtest notnull;

INSERT INTO public.exam (person, exam_year, subject, status, ball100, ball12,dpalevel, ball, exam_organization)
select distinct
outid, year, fratest, frateststatus, fraball100, fraball12, fradpalevel, fraball,
case 
when (select count(*) from organizations
 		where name = fraptname) = 0
 		then null
else fraptname
end
from zno_persons as z1
where fratest notnull;

INSERT INTO public.exam (person, exam_year, subject, status, ball100, ball12,dpalevel, ball, exam_organization)
select distinct
outid, year, deutest, deuteststatus, deuball100, deuball12, deudpalevel, deuball, 
case 
when (select count(*) from organizations
 		where name = deuptname) = 0
 		then null
else deuptname
end
from zno_persons as z1
where deutest notnull;

INSERT INTO public.exam (person, exam_year, subject, status, ball100, ball12,dpalevel, ball, exam_organization)
select distinct
outid, year, spatest, spateststatus, spaball100, spaball12, spadpalevel, spaball, 
case 
when (select count(*) from organizations
 		where name = spaptname) = 0
 		then null
else spaptname
end
from zno_persons as z1
where spatest notnull;