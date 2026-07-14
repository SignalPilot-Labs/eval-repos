# Reference Table Snapshot

## circuits (77 rows)
| Column | Type |
|--------|------|
| circuitId | INTEGER |
| circuitRef | VARCHAR |
| name | VARCHAR |
| location | VARCHAR |
| country | VARCHAR |
| lat | DOUBLE |
| lng | DOUBLE |
| alt | INTEGER |
| url | VARCHAR |

Sample:
| circuitId | circuitRef | name | location | country | lat | lng | alt | url |
|---|---|---|---|---|---|---|---|---|
| 1 | albert_park | Albert Park Grand Prix Circuit | Melbourne | Australia | -37.8497 | 144.968 | 10 | http://en.wikipedia.org/wiki/Melbourne_Grand_Prix_Circuit |
| 2 | sepang | Sepang International Circuit | Kuala Lumpur | Malaysia | 2.76083 | 101.738 | 18 | http://en.wikipedia.org/wiki/Sepang_International_Circuit |
| 3 | bahrain | Bahrain International Circuit | Sakhir | Bahrain | 26.0325 | 50.5106 | 7 | http://en.wikipedia.org/wiki/Bahrain_International_Circuit |

## constructor_results (12,545 rows)
| Column | Type |
|--------|------|
| constructorResultsId | INTEGER |
| raceId | INTEGER |
| constructorId | INTEGER |
| points | DOUBLE |
| status | VARCHAR |

Sample:
| constructorResultsId | raceId | constructorId | points | status |
|---|---|---|---|---|
| 1 | 18 | 1 | 14.0 | None |
| 2 | 18 | 2 | 8.0 | None |
| 3 | 18 | 3 | 9.0 | None |

## constructor_standings (13,311 rows)
| Column | Type |
|--------|------|
| constructorStandingsId | INTEGER |
| raceId | INTEGER |
| constructorId | INTEGER |
| points | DOUBLE |
| position | INTEGER |
| positionText | VARCHAR |
| wins | INTEGER |

Sample:
| constructorStandingsId | raceId | constructorId | points | position | positionText | wins |
|---|---|---|---|---|---|---|
| 1 | 18 | 1 | 14.0 | 1 | 1 | 1 |
| 2 | 18 | 2 | 8.0 | 3 | 3 | 0 |
| 3 | 18 | 3 | 9.0 | 2 | 2 | 0 |

## constructors (212 rows)
| Column | Type |
|--------|------|
| constructorId | INTEGER |
| constructorRef | VARCHAR |
| name | VARCHAR |
| nationality | VARCHAR |
| url | VARCHAR |

Sample:
| constructorId | constructorRef | name | nationality | url |
|---|---|---|---|---|
| 1 | mclaren | McLaren | British | http://en.wikipedia.org/wiki/McLaren |
| 2 | bmw_sauber | BMW Sauber | German | http://en.wikipedia.org/wiki/BMW_Sauber |
| 3 | williams | Williams | British | http://en.wikipedia.org/wiki/Williams_Grand_Prix_Engineering |

## driver_standings (34,680 rows)
| Column | Type |
|--------|------|
| driverStandingsId | INTEGER |
| raceId | INTEGER |
| driverId | INTEGER |
| points | DOUBLE |
| position | INTEGER |
| positionText | VARCHAR |
| wins | INTEGER |

Sample:
| driverStandingsId | raceId | driverId | points | position | positionText | wins |
|---|---|---|---|---|---|---|
| 1 | 18 | 1 | 10.0 | 1 | 1 | 1 |
| 2 | 18 | 2 | 8.0 | 2 | 2 | 0 |
| 3 | 18 | 3 | 6.0 | 3 | 3 | 0 |

## drivers (860 rows)
| Column | Type |
|--------|------|
| driverId | INTEGER |
| driverRef | VARCHAR |
| number | INTEGER |
| code | VARCHAR |
| forename | VARCHAR |
| surname | VARCHAR |
| dob | DATE |
| nationality | VARCHAR |
| url | VARCHAR |

Sample:
| driverId | driverRef | number | code | forename | surname | dob | nationality | url |
|---|---|---|---|---|---|---|---|---|
| 1 | hamilton | 44 | HAM | Lewis | Hamilton | 1985-01-07 | British | http://en.wikipedia.org/wiki/Lewis_Hamilton |
| 2 | heidfeld | None | HEI | Nick | Heidfeld | 1977-05-10 | German | http://en.wikipedia.org/wiki/Nick_Heidfeld |
| 3 | rosberg | 6 | ROS | Nico | Rosberg | 1985-06-27 | German | http://en.wikipedia.org/wiki/Nico_Rosberg |

## lap_times (580,619 rows)
| Column | Type |
|--------|------|
| raceId | INTEGER |
| driverId | INTEGER |
| lap | INTEGER |
| position | INTEGER |
| time | VARCHAR |
| milliseconds | INTEGER |

Sample:
| raceId | driverId | lap | position | time | milliseconds |
|---|---|---|---|---|---|
| 841 | 20 | 1 | 1 | 1:38.109 | 98109 |
| 841 | 20 | 2 | 1 | 1:33.006 | 93006 |
| 841 | 20 | 3 | 1 | 1:32.713 | 92713 |

## pit_stops (11,120 rows)
| Column | Type |
|--------|------|
| raceId | INTEGER |
| driverId | INTEGER |
| stop | INTEGER |
| lap | INTEGER |
| time | VARCHAR |
| duration | VARCHAR |
| milliseconds | INTEGER |

Sample:
| raceId | driverId | stop | lap | time | duration | milliseconds |
|---|---|---|---|---|---|---|
| 841 | 153 | 1 | 1 | 17:05:23 | 26.898 | 26898 |
| 841 | 30 | 1 | 1 | 17:05:52 | 25.021 | 25021 |
| 841 | 17 | 1 | 11 | 17:20:48 | 23.426 | 23426 |

## position_descriptions (6 rows)
| Column | Type |
|--------|------|
| position_text | VARCHAR |
| position_desc | VARCHAR |

Sample:
| position_text | position_desc |
|---|---|
| D | disqualified |
| E | excluded |
| F | failed to qualify |

## qualifying (10,334 rows)
| Column | Type |
|--------|------|
| qualifyId | INTEGER |
| raceId | INTEGER |
| driverId | INTEGER |
| constructorId | INTEGER |
| number | INTEGER |
| position | INTEGER |
| q1 | VARCHAR |
| q2 | VARCHAR |
| q3 | VARCHAR |

Sample:
| qualifyId | raceId | driverId | constructorId | number | position | q1 | q2 | q3 |
|---|---|---|---|---|---|---|---|---|
| 1 | 18 | 1 | 1 | 22 | 1 | 1:26.572 | 1:25.187 | 1:26.714 |
| 2 | 18 | 9 | 2 | 4 | 2 | 1:26.103 | 1:25.315 | 1:26.869 |
| 3 | 18 | 5 | 1 | 23 | 3 | 1:25.664 | 1:25.452 | 1:27.079 |

## races (1,125 rows)
| Column | Type |
|--------|------|
| raceId | INTEGER |
| year | INTEGER |
| round | INTEGER |
| circuitId | INTEGER |
| name | VARCHAR |
| date | DATE |
| time | VARCHAR |
| url | VARCHAR |
| fp1_date | DATE |
| fp1_time | VARCHAR |
| fp2_date | DATE |
| fp2_time | VARCHAR |
| fp3_date | DATE |
| fp3_time | VARCHAR |
| quali_date | DATE |
| quali_time | VARCHAR |
| sprint_date | DATE |
| sprint_time | VARCHAR |

Sample:
| raceId | year | round | circuitId | name | date | time | url | fp1_date | fp1_time | fp2_date | fp2_time | fp3_date | fp3_time | quali_date | quali_time | sprint_date | sprint_time |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 2009 | 1 | 1 | Australian Grand Prix | 2009-03-29 | 06:00:00 | http://en.wikipedia.org/wiki/2009_Australian_Grand_Prix | None | None | None | None | None | None | None | None | None | None |
| 2 | 2009 | 2 | 2 | Malaysian Grand Prix | 2009-04-05 | 09:00:00 | http://en.wikipedia.org/wiki/2009_Malaysian_Grand_Prix | None | None | None | None | None | None | None | None | None | None |
| 3 | 2009 | 3 | 17 | Chinese Grand Prix | 2009-04-19 | 07:00:00 | http://en.wikipedia.org/wiki/2009_Chinese_Grand_Prix | None | None | None | None | None | None | None | None | None | None |

## results (26,599 rows)
| Column | Type |
|--------|------|
| resultId | INTEGER |
| raceId | INTEGER |
| driverId | INTEGER |
| constructorId | INTEGER |
| number | INTEGER |
| grid | INTEGER |
| position | INTEGER |
| positionText | VARCHAR |
| positionOrder | INTEGER |
| points | DOUBLE |
| laps | INTEGER |
| time | VARCHAR |
| milliseconds | INTEGER |
| fastestLap | INTEGER |
| rank | INTEGER |
| fastestLapTime | VARCHAR |
| fastestLapSpeed | DOUBLE |
| statusId | INTEGER |

Sample:
| resultId | raceId | driverId | constructorId | number | grid | position | positionText | positionOrder | points | laps | time | milliseconds | fastestLap | rank | fastestLapTime | fastestLapSpeed | statusId |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 18 | 1 | 1 | 22 | 1 | 1 | 1 | 1 | 10.0 | 58 | 1:34:50.616 | 5690616 | 39 | 2 | 1:27.452 | 218.3 | 1 |
| 2 | 18 | 2 | 2 | 3 | 5 | 2 | 2 | 2 | 8.0 | 58 | +5.478 | 5696094 | 41 | 3 | 1:27.739 | 217.586 | 1 |
| 3 | 18 | 3 | 3 | 7 | 7 | 3 | 3 | 3 | 6.0 | 58 | +8.163 | 5698779 | 41 | 5 | 1:28.090 | 216.719 | 1 |

## seasons (75 rows)
| Column | Type |
|--------|------|
| year | INTEGER |
| url | VARCHAR |

Sample:
| year | url |
|---|---|
| 2009 | http://en.wikipedia.org/wiki/2009_Formula_One_season |
| 2008 | http://en.wikipedia.org/wiki/2008_Formula_One_season |
| 2007 | http://en.wikipedia.org/wiki/2007_Formula_One_season |

## status (139 rows)
| Column | Type |
|--------|------|
| statusId | INTEGER |
| status | VARCHAR |

Sample:
| statusId | status |
|---|---|
| 1 | Finished |
| 2 | Disqualified |
| 3 | Accident |
