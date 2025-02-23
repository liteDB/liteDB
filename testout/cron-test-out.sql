.load dist/cron

select cron_match('2000-01-01 00:03:00', '*/3 * * * *');
[{"cron_match('2000-01-01 00:03:00', '*/3 * * * *')":1}]

create table test1(date TEXT);
insert into test1(date) values ('2000-01-04 10:27:00'), ('2000-01-04 10:36:00');
insert into test1(date) values ('2000-01-06 11:30:00');

select date from test1 where cron_match(date, '*/9 */10 * * *');
[{"date":"2000-01-04 10:27:00"},
{"date":"2000-01-04 10:36:00"}]
select date from test1;
[{"date":"2000-01-04 10:27:00"},
{"date":"2000-01-04 10:36:00"},
{"date":"2000-01-06 11:30:00"}]
