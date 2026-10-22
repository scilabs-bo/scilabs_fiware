GRANT SELECT ON "mtsmartcity"."etfroggit-wh-4000-se" TO grafanareader;
GRANT SELECT ON "mtsmartcity"."etwater-level-sensor" TO grafanareader;
GRANT USAGE ON SCHEMA "mtsmartcity" TO grafanareader;
ALTER DATABASE quantumleap SET search_path TO 'mtsmartcity';
ALTER ROLE grafanareader SET search_path TO 'mtsmartcity';
