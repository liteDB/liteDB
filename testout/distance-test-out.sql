.load dist/distance

create table locations(id, name, lat, lng);
insert into locations(name, lat, lng) values
    ('Paris', 48.8534100, 2.3488000),
    ('Berlin', 52.5243700, 13.4105300),
    ('Oslo', 39.9075000, 116.3972300),
    ('Warsaw', 52.2297700, 21.0117800);

SELECT
    name,
    printf('%.6f',DISTANCE(lat, lng, 33.8120742,-117.9188774)) as dist
FROM locations
ORDER BY dist
LIMIT 0, 10;
[{"name":"Oslo","dist":"10112.906126"},
{"name":"Paris","dist":"9100.402665"},
{"name":"Berlin","dist":"9329.907944"},
{"name":"Warsaw","dist":"9660.026694"}]


SELECT
    name,
    printf('%.6f', DISTANCE(lat, lng, 48.8534100, 2.3488000)) as dist
FROM locations
ORDER BY dist
LIMIT 0, 10;
[{"name":"Paris","dist":"0.000000"},
{"name":"Warsaw","dist":"1368.413596"},
{"name":"Oslo","dist":"8225.740440"},
{"name":"Berlin","dist":"879.376193"}]
