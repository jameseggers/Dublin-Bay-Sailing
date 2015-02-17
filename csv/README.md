### CSV

The CSV files herein are a transcript of the DBRC handouts.

##### `buoys.csv`

Taken from the xxxx handout.

Each line described the coordinates, name and symbol of each Dublin Bay buoy.

Columns:

 * Latitude
 * Longitude
 * Name
 * Symbol

Coordinates are in degree, decimal minute format, i.e.

```
DDD MM.SS ( N | W )
```

##### `listings.csv`

Taken from the 2010 handout.

Each line contains the number and buoy listing of each course. The buoy listing
is a space-separated list of buoy symbols followed either by a `P` (Port) or
`S` (Starboard).

The lines are grouped in fives, each group corresponding to the five possible
courses per wind direction and starting buoys.

Note: The groups are separated by single-line comments starting with '#'.

##### `courses.csv`

Taken from the 2010 handout.

Each line contains the number, symbol and wind direction corresponding to each
of the 16 possible starting points.

The numbers of the five alternative courses associated with each starting buoy,
as listed in `listings.csv`, are found in the interval
`[(n * 5), ((n * 5) + 4)]`, where `n` is the number of the starting buoy in
`courses.csv`.

Note: This relationship was imposed manually, so further additions should take
care to preserver it.
