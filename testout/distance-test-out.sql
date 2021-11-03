.load dist/distance

create table locations(id, name, lat, lng);
insert into locations(name, lat, lng) values
    ('Paris', 48.8534100, 2.3488000),
    ('Berlin', 52.5243700, 13.4105300),
    ('Oslo', 39.9075000, 116.3972300),
    ('Warsaw', 52.2297700, 21.0117800);

SELECT
    name,
    DISTANCE(lat, lng, 33.8120742,-117.9188774) as dist
FROM locations
ORDER BY dist
LIMIT 0, 10;
[{"name":"Paris","dist":9100.4026650858289571},
{"name":"Berlin","dist":9329.9079438339624914},
{"name":"Warsaw","dist":9660.0266937862961924},
{"name":"Oslo","dist":10112.906125794549616}]



SELECT
    name,
    DISTANCE(lat, lng, 48.8534100, 2.3488000) as dist
FROM locations
ORDER BY dist
LIMIT 0, 10;
[{"name":"Paris","dist":0.0},
{"name":"Berlin","dist":879.37619286250328087},
{"name":"Warsaw","dist":1368.4135962129493346},
{"name":"Oslo","dist":8225.7404396676285784}]
