CREATE TABLE station (
    SiteID    VARCHAR (6)  PRIMARY KEY,
    District  VARCHAR (3),
    SiteName  VARCHAR (50),
    Start     INTEGER,
    [End]     INTEGER,
    Latitude  FLOAT,
    Longitude DECIMAL,
    Source    VARCHAR (15),
    State     VARCHAR (3),
    Height    DECIMAL,
    BarHeight DECIMAL,
    WMO       VARCHAR (5) 
);
