USE BIT_SWD03

-- Clean up
IF (EXISTS (SELECT 1
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME = 'Brevet_Rider'))
BEGIN
    DROP TABLE Brevet_Rider
END

IF (EXISTS (SELECT 1
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME = 'Brevet'))
BEGIN
    DROP TABLE Brevet
END

IF (EXISTS (SELECT 1
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME = 'Rider'))
BEGIN
    DROP TABLE Rider
END

IF (EXISTS (SELECT 1
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME = 'Club'))
BEGIN
    DROP TABLE Club
END

-- Brevet
CREATE TABLE Brevet(
    brevetId INT IDENTITY NOT NULL,
    distance INT NOT NULL,
    brevetDate DATE NOT NULL,
    brevetTime TIME NOT NULL,
    location NVARCHAR(20) NOT NULL,
    climbing INT NOT NULL,
    CONSTRAINT PK_Brevet PRIMARY KEY CLUSTERED (brevetId),
    CONSTRAINT CK_Brevet_distance CHECK (distance IN (200, 300, 400, 600, 1000, 1200)),
    CONSTRAINT CK_Brevet_climbing CHECK (climbing BETWEEN 0 AND 99999)
)

-- Club
CREATE TABLE Club(
    clubId INT IDENTITY NOT NULL,
    clubName NVARCHAR(20) NOT NULL,
    city NVARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Club PRIMARY KEY CLUSTERED (clubId),
    CONSTRAINT UK_Club_clubName UNIQUE (clubName)
)

-- Rider
CREATE TABLE Rider(
    riderId INT IDENTITY NOT NULL,
    familyName NVARCHAR(20) NOT NULL,
    givenName NVARCHAR(20) NOT NULL,
    gender CHAR(1) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(20),
    clubId INT NOT NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    role VARCHAR(5) NOT NULL,
    CONSTRAINT PK_Rider PRIMARY KEY CLUSTERED (riderId),
    CONSTRAINT FK_Rider_Club FOREIGN KEY (clubId) REFERENCES Club(clubId),
    CONSTRAINT UK_Rider_username UNIQUE (username), 
    CONSTRAINT CK_Rider_gender CHECK (gender IN ('F', 'M')),
    CONSTRAINT CK_Rider_role CHECK (role IN ('user', 'admin'))
)

-- Brevet_Rider
CREATE TABLE Brevet_Rider(
    brevetId INT NOT NULL,
    riderId INT NOT NULL,
    isCompleted CHAR(1) NOT NULL,
    finishingTime CHAR(5) NOT NULL DEFAULT '00:00',
    CONSTRAINT PK_BrevetRider PRIMARY KEY CLUSTERED (brevetId, riderId),
    CONSTRAINT FK_BrevetRider_Brevet FOREIGN KEY (brevetId) REFERENCES Brevet(brevetId),
    CONSTRAINT FK_BrevetRider_Rider FOREIGN KEY (riderId) REFERENCES Rider(riderId),
    CONSTRAINT CK_BrevetRider_finishingTime CHECK (
        finishingTime LIKE '__:__'
        AND ISNUMERIC(SUBSTRING(finishingTime, 1, 2)) = 1
        AND ISNUMERIC(SUBSTRING(finishingTime, 4, 2)) = 1
        AND CONVERT(INT, SUBSTRING(finishingTime, 4, 2)) BETWEEN 0 AND 60
    )
)

-- Create sample data

-- Insert into Club
SET IDENTITY_INSERT Club ON;
INSERT INTO Club (clubId, clubName, city, email) VALUES
(1, 'Audax Vietnam', 'Hanoi', 'info@audax.vn'),
(2, 'Saigon Cyclists', 'HCM', 'sg@cycle.com'),
(3, 'Da Nang Riders', 'Da Nang', 'dn@riders.vn'),
(4, 'Hue Wheels', 'Hue', 'hue@wheels.com'),
(5, 'Can Tho Velo', 'Can Tho', 'ct@velo.vn'),
(6, 'Dalat Climbers', 'Dalat', 'dl@climber.vn'),
(7, 'Nha Trang Bike', 'Nha Trang', 'nt@bike.vn'),
(8, 'Vung Tau Team', 'Vung Tau', 'vt@team.vn'),
(9, 'Hai Phong Velo', 'Hai Phong', 'hp@velo.vn'),
(10, 'Quang Ninh Ride', 'Quang Ninh', 'qn@ride.vn'),
(11, 'Phu Quoc Bike', 'Phu Quoc', 'pq@bike.vn'),
(12, 'Sapa Trek', 'Sapa', 'sapa@trek.vn'),
(13, 'Mekong Delta', 'My Tho', 'mk@delta.vn'),
(14, 'Tay Ninh Cycle', 'Tay Ninh', 'tn@cycle.vn'),
(15, 'Bien Hoa Road', 'Bien Hoa', 'bh@road.vn'),
(16, 'Rach Gia Club', 'Rach Gia', 'rg@club.vn'),
(17, 'Vinh City Ride', 'Vinh', 'vinh@ride.vn'),
(18, 'Nam Dinh Wheel', 'Nam Dinh', 'nd@wheel.vn'),
(19, 'Thai Binh Bike', 'Thai Binh', 'tb@bike.vn'),
(20, 'Long An Velo', 'Tan An', 'la@velo.vn');
SET IDENTITY_INSERT Club OFF;

-- Insert into Brevet
SET IDENTITY_INSERT Brevet ON;
INSERT INTO Brevet (brevetId, distance, brevetDate, brevetTime, location, climbing) VALUES
(1, 200, '2023-01-15', '06:00:00', 'Hanoi', 1200),
(2, 300, '2023-02-10', '05:00:00', 'HCM', 2500),
(3, 400, '2023-03-05', '04:00:00', 'Da Nang', 4000),
(4, 600, '2023-04-20', '03:00:00', 'Dalat', 8000),
(5, 1000, '2023-05-15', '00:00:00', 'Hanoi-Hue', 12000),
(6, 1200, '2023-06-01', '02:00:00', 'PBP Qualifier', 15000),
(7, 200, '2023-07-10', '06:30:00', 'Hue', 1000),
(8, 200, '2023-08-15', '06:00:00', 'Nha Trang', 1500),
(9, 300, '2023-09-20', '05:30:00', 'Vung Tau', 2200),
(10, 400, '2023-10-25', '04:00:00', 'Can Tho', 500),
(11, 600, '2023-11-15', '03:00:00', 'Hanoi Loop', 7000),
(12, 200, '2024-01-20', '06:00:00', 'Tay Ninh', 1800),
(13, 300, '2024-02-15', '05:00:00', 'Phu Quoc', 3000),
(14, 400, '2024-03-10', '04:30:00', 'Sapa', 9000),
(15, 200, '2024-04-05', '06:00:00', 'Mekong', 300),
(16, 200, '2024-05-10', '06:00:00', 'Hanoi North', 2000),
(17, 300, '2024-06-15', '05:00:00', 'HCM South', 1200),
(18, 400, '2024-07-20', '04:00:00', 'Da Lat Peak', 9500),
(19, 600, '2024-08-25', '03:00:00', 'Central Coast', 5000),
(20, 200, '2024-09-30', '06:00:00', 'Long An', 400);
SET IDENTITY_INSERT Brevet OFF;

-- Insert into Rider
SET IDENTITY_INSERT Rider ON;
INSERT INTO Rider (riderId, familyName, givenName, gender, phone, email, clubId, username, password, role) VALUES
(1, 'Nguyen', 'An', 'M', '0901234567', 'an@n.co', 1, 'user01', 'pwd01', 'admin'),
(2, 'Tran', 'Binh', 'M', '0902345678', 'binh@t.co', 2, 'user02', 'pwd02', 'user'),
(3, 'Le', 'Chi', 'F', '0903456789', 'chi@l.co', 3, 'user03', 'pwd03', 'user'),
(4, 'Pham', 'Dung', 'M', '0904567890', 'dung@p.co', 4, 'user04', 'pwd04', 'user'),
(5, 'Hoang', 'Em', 'F', '0905678901', 'em@h.co', 5, 'user05', 'pwd05', 'user'),
(6, 'Phan', 'Giang', 'M', '0906789012', 'giang@p.co', 6, 'user06', 'pwd06', 'user'),
(7, 'Vu', 'Hoa', 'F', '0907890123', 'hoa@v.co', 7, 'user07', 'pwd07', 'user'),
(8, 'Dang', 'Hung', 'M', '0908901234', 'hung@d.co', 8, 'user08', 'pwd08', 'user'),
(9, 'Bui', 'Inh', 'M', '0909012345', 'inh@b.co', 9, 'user09', 'pwd09', 'user'),
(10, 'Do', 'Khoa', 'M', '0900123456', 'khoa@d.co', 10, 'user10', 'pwd10', 'user'),
(11, 'Ho', 'Lan', 'F', '0901122334', 'lan@h.co', 11, 'user11', 'pwd11', 'user'),
(12, 'Ngo', 'Minh', 'M', '0902233445', 'minh@n.co', 12, 'user12', 'pwd12', 'user'),
(13, 'Duong', 'Nam', 'M', '0903344556', 'nam@d.co', 13, 'user13', 'pwd13', 'user'),
(14, 'Ly', 'Oanh', 'F', '0904455667', 'oanh@l.co', 14, 'user14', 'pwd14', 'user'),
(15, 'Trinh', 'Phuong', 'F', '0905566778', 'ph@t.co', 15, 'user15', 'pwd15', 'user'),
(16, 'Truong', 'Quan', 'M', '0906677889', 'quan@t.co', 16, 'user16', 'pwd16', 'user'),
(17, 'Dinh', 'Son', 'M', '0907788990', 'son@d.co', 17, 'user17', 'pwd17', 'user'),
(18, 'Lam', 'Tu', 'F', '0908899001', 'tu@l.co', 18, 'user18', 'pwd18', 'user'),
(19, 'Mai', 'Vinh', 'M', '0909900112', 'vinh@m.co', 19, 'user19', 'pwd19', 'user'),
(20, 'Quach', 'Xuan', 'F', '0900011223', 'xuan@q.co', 20, 'user20', 'pwd20', 'user');
SET IDENTITY_INSERT Rider OFF;

-- Insert into Brevet_Rider
INSERT INTO Brevet_Rider (brevetId, riderId, isCompleted, finishingTime) VALUES
(1, 1, 'Y', '08:30'),
(1, 2, 'Y', '09:15'),
(2, 2, 'Y', '12:45'),
(2, 3, 'Y', '13:00'),
(3, 3, 'Y', '18:20'),
(3, 4, 'N', '00:00'),
(4, 4, 'Y', '25:30'),
(4, 5, 'Y', '28:10'),
(5, 5, 'Y', '60:00'),
(5, 6, 'Y', '72:00'),
(6, 6, 'Y', '80:00'),
(6, 7, 'N', '00:00'),
(7, 7, 'Y', '07:45'),
(8, 8, 'Y', '08:10'),
(9, 9, 'Y', '14:20'),
(10, 10, 'Y', '19:50'),
(11, 11, 'Y', '35:00'),
(12, 12, 'Y', '08:55'),
(13, 13, 'Y', '15:20'),
(14, 14, 'N', '00:00');
