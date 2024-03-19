Gather 1% stats, show stats
Cardinality (high-unique, low-shared)
Gather 100% stats
Beware that showing an explain plan may actually execute the statement

select * from mock_data; -- table access full
select * from mock_data where id = 1; --table access full

create unique index id_index on mock_data(id);
select * from mock_data where id = 1; --index unique scan, table access by rowid
select id from mock_data where id = 1; --index unique scan

select count(1) from mock_data; --table access full
select count(id) from mock_data; --index fast full scan
select count(distinct id) from mock_data; --table access full into hash into aggregate

select * from mock_data where last_name like 'R%'; --table access full
create index ln_index on mock_data(last_name);
select * from mock_data where last_name like 'R%'; --still table access full
select last_name from mock_data where last_name like 'R%'; --index range scan
select last_name from mock_data where last_name not like 'R%'; --index fast full scan

create index state_index on mock_data(state);
select * from mock_data where state = 'VA'; --table access full
SELECT segment_name, segment_type, bytes/1024/1024 AS size_in_mb FROM user_segments WHERE segment_name = 'STATE_INDEX';
select state, count(*) from mock_data group by state; --table access full

drop index state_index;
create bitmap index state_index on mock_data(state) ;
select state, count(*) from mock_data group by state; --bitmap conversion

select last_name, first_name from mock_data where last_name like 'R%';
create index name_index on mock_data (last_name, first_name);
drop index ln_index;
