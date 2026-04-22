USE BIT_SWD03;
GO

-- Index for FK_Rider_Club in Rider table
CREATE INDEX IX_Rider_clubId ON Rider(clubId);
GO

-- Index for FK_BrevetRider_Rider in Brevet_Rider table
-- (Note: brevetId is the first column of the clustered PK, so it is already indexed)
CREATE INDEX IX_BrevetRider_riderId ON Brevet_Rider(riderId);
GO

-- Performance indexes for Brevet table
CREATE INDEX IX_Brevet_brevetDate ON Brevet(brevetDate);
CREATE INDEX IX_Brevet_distance ON Brevet(distance);
CREATE INDEX IX_Brevet_location ON Brevet(location);
GO

-- Performance index for Rider table (searching by name)
CREATE INDEX IX_Rider_Name ON Rider(familyName, givenName);
GO

-- Performance index for Club table (filtering by city)
CREATE INDEX IX_Club_city ON Club(city);
GO