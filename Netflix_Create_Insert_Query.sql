#-----------------------------------------------------------------
# SECTION 1: TABLE CREATION
#-----------------------------------------------------------------


# Initializing Database
CREATE DATABASE NETFLIX;
USE NETFLIX;

# Tables are created in order of precendent
# The root parent tables of our implementation are CUSTOMER, GENRE, DEVICE & MEDIA
# Every other table has at least one other dependency
# One Possible Implementation:
# CUSTOMER, GENRE, DEVICE, MEDIA, SUBSCRIPTION, PAYMENT, PROFILE, 
# CUSTOMER_DEVICE, PREFERRED_GENRE, MEDIA_GENRE, WATCH_RECORD, (every sub-table of Media)

# Above is just one possible working order, but below the implementation imagines working through both the ER and LD Diagram visually 
# spotting dependencies

# Primary Key Standard Format: '[First Initial of Table]NNNN' 
# Eg a record in CUSTOMER: 'C0045' 
# Eg a record in MEDIA: 'M9085' 
# PAYMENT & PROFILE are the only exceptions to this, their alphabetical prefix for IDs are 'P' and 'PR' respectively
# PROFILE is the only table which stores a 6 character ID

CREATE TABLE CUSTOMER (
    CustomerID CHAR(5) PRIMARY KEY, #C....
    Full_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Birth_Date DATE,
    Billing_Address VARCHAR(255),
    CreditCardNum CHAR(16)
);

CREATE TABLE SUBSCRIPTION (
    SubscriptionID CHAR(5) PRIMARY KEY, #S....
    Subscription_Tier VARCHAR(50) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE,
    CustomerID CHAR(5),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);

CREATE TABLE PAYMENT (
    PaymentID CHAR(5) PRIMARY KEY, #P....
    SubscriptionID CHAR(5),
    Amount DECIMAL(10, 2) NOT NULL,
    Payment_Date DATE NOT NULL,
    FOREIGN KEY (SubscriptionID) REFERENCES SUBSCRIPTION(SubscriptionID)
); # Everything related to Customer Admin established

CREATE TABLE DEVICE (
    DeviceID CHAR(5) PRIMARY KEY, #D....
    Device_Type VARCHAR(50) NOT NULL
); 

CREATE TABLE CUSTOMER_DEVICE (
    DeviceID CHAR(5), 
    CustomerID CHAR(5),
    Paired_Date DATE NOT NULL,
    PRIMARY KEY (DeviceID, CustomerID),
    FOREIGN KEY (DeviceID) REFERENCES DEVICE(DeviceID),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
); 

CREATE TABLE PROFILE (
    ProfileID CHAR(6) PRIMARY KEY, #PR....
    PName VARCHAR(100) NOT NULL,
    Create_Date DATE NOT NULL,
    CustomerID CHAR(5),
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
); # Beggining to work on records related to Customers relation with Media consumption

CREATE TABLE GENRE (
    GenreID CHAR(5) PRIMARY KEY, # G....
    Genre_Name VARCHAR(50) NOT NULL
);

CREATE TABLE PREFERRED_GENRE (
    ProfileID CHAR(6),
    GenreID CHAR(5),
    PRIMARY KEY (ProfileID, GenreID),
    FOREIGN KEY (ProfileID) REFERENCES PROFILE(ProfileID),
    FOREIGN KEY (GenreID) REFERENCES GENRE(GenreID)
);

CREATE TABLE MEDIA (
    MediaID CHAR(5) PRIMARY KEY, # M....
    Title VARCHAR(255) NOT NULL,
    Release_Date DATE,
    Rating DECIMAL(3, 1),
    Media_Type ENUM('Movie', 'Series') NOT NULL
);

CREATE TABLE MEDIA_GENRE (
    MediaID CHAR(5),
    GenreID CHAR(5),
    PRIMARY KEY (MediaID, GenreID),
    FOREIGN KEY (MediaID) REFERENCES MEDIA(MediaID),
    FOREIGN KEY (GenreID) REFERENCES GENRE(GenreID)
);

CREATE TABLE WATCH_RECORD (
    ProfileID CHAR(6),
    DeviceID CHAR(5),
    MediaID CHAR(5),
    Watch_Date DATE,
    Watch_Time TIME,
    Watch_Duration INT, # Minutes!
    PRIMARY KEY (ProfileID, DeviceID, MediaID, Watch_Date, Watch_Time),
    FOREIGN KEY (ProfileID) REFERENCES PROFILE(ProfileID),
    FOREIGN KEY (DeviceID) REFERENCES DEVICE(DeviceID),
    FOREIGN KEY (MediaID) REFERENCES MEDIA(MediaID)
);

CREATE TABLE ACTOR (
    MediaID CHAR(5),
    Actor VARCHAR(100),
    PRIMARY KEY (MediaID, Actor),
    FOREIGN KEY (MediaID) REFERENCES MEDIA(MediaID)
);

CREATE TABLE DIRECTOR (
    MediaID CHAR(5),
    Director VARCHAR(100),
    PRIMARY KEY (MediaID, Director),
    FOREIGN KEY (MediaID) REFERENCES MEDIA(MediaID)
);

CREATE TABLE MOVIE (
    MovieID CHAR(5) PRIMARY KEY,
    Run_Time INT NOT NULL,
    FOREIGN KEY (MovieID) REFERENCES MEDIA(MediaID)
);

CREATE TABLE SERIES (
    SeriesID CHAR(5),
    Episode_Title VARCHAR(255),
    Season_Num INT,
    Episode_Num INT,
    PRIMARY KEY (SeriesID, Episode_Title, Season_Num, Episode_Num),
    FOREIGN KEY (SeriesID) REFERENCES MEDIA(MediaID)
);


#-----------------------------------------------------------------
# SECTION 2: DATA INSERTION
#-----------------------------------------------------------------

# Data for CUSTOMER
INSERT INTO CUSTOMER VALUES
('C4856', 'Alice Hill', 'alice@example.com', '1985-07-12', '123 Elm St', '1234123412341234'),
('C2164', 'Bob Brown', 'bob@example.com', '1992-03-03', '456 Oak St', '5678567856785678'),
('C3891', 'Charlie Green', 'charlie@example.com', '1980-11-20', '789 Pine St', '9876987698769876'),
('C6458', 'Daisy Clarke', 'daisy@example.com', '1995-04-25', '321 Maple St', '4321432143214321'),
('C2741', 'Eve White', 'eve@example.com', '1990-08-14', '654 Birch St', '8765876587658765'),
('C3489', 'Frank Black', 'frank@example.com', '1983-12-11', '987 Cedar St', '3456345634563456'),
('C5792', 'Grace Scott', 'grace@example.com', '1991-05-09', '159 Willow St', '7654765476547654'),
('C8593', 'Henry Young', 'henry@example.com', '1986-06-18', '951 Palm St', '8767876787678767'),
('C9124', 'Ivy King', 'ivy@example.com', '1994-09-22', '357 Fir St', '2345234523452345'),
('C1111', 'Jack Lane', 'jack@example.com', '1993-02-27', '852 Spruce St', '6543654365436543'),
('C1012', 'Laura Dean', 'laura@example.com', '1987-11-08', '204 Sequoia St', '5432543254325432'),
('C1395', 'Mark Lewis', 'mark@example.com', '1990-12-15', '100 Sycamore St', '3456345634563456');

# Data for SUBSCRIPTION
INSERT INTO SUBSCRIPTION VALUES
('S4856', 'Standard I', '2023-01-01', NULL, 'C4856'),
('S2164', 'Standard II', '2022-11-01', NULL, 'C2164'),
('S3891', 'Premium', '2021-09-15', NULL, 'C3891'),
('S6458', 'Standard II', '2023-04-20', NULL, 'C6458'),
('S2741', 'Standard I', '2022-05-18', NULL, 'C2741'),
('S3489', 'Premium', '2023-03-01', NULL, 'C3489'),
('S5792', 'Standard II', '2024-01-01', NULL, 'C5792'),
('S8593', 'Premium', '2023-07-10', NULL, 'C8593'),
('S9124', 'Standard I', '2024-09-20', NULL, 'C9124'),
('S1111', 'Standard II', '2023-08-01', NULL, 'C1111'),
('S1012', 'Premium', '2022-10-11', NULL, 'C1012'),
('S1395', 'Standard I', '2024-02-27', NULL, 'C1395');

# Data for PAYMENT
INSERT INTO PAYMENT VALUES
('P1001', 'S4856', 13.99, '2023-01-01'),
('P1002', 'S2164', 19.99, '2022-11-01'),
('P1003', 'S3891', 25.99, '2021-09-15'),
('P1004', 'S6458', 19.99, '2023-04-20'),
('P1005', 'S2741', 13.99, '2022-05-18'),
('P1006', 'S3489', 25.99, '2023-03-01'),
('P1007', 'S5792', 19.99, '2024-01-01'),
('P1008', 'S8593', 25.99, '2023-07-10'),
('P1009', 'S9124', 13.99, '2024-09-20'),
('P1010', 'S1111', 19.99, '2023-08-01'),
('P1011', 'S1012', 25.99, '2022-10-11'),
('P1012', 'S1395', 13.99, '2024-02-27');

# Data for PROFILE
INSERT INTO PROFILE VALUES
('PR1201', 'Silent Shadow', '2023-01-02', 'C4856'),
('PR3427', 'Lone Wolf', '2022-11-03', 'C2164'),
('PR5932', 'Brave Mind', '2021-09-16', 'C3891'),
('PR7649', 'Free Spirit', '2023-04-21', 'C6458'),
('PR9812', 'Deep Thought', '2022-05-20', 'C2741'),
('PR3058', 'Mighty Eagle', '2023-03-02', 'C3489'),
('PR4875', 'Gentle Breeze', '2024-01-03', 'C5792'),
('PR6781', 'Steady Anchor', '2023-07-12', 'C8593'),
('PR1345', 'Bold Spirit', '2024-09-21', 'C9124'),
('PR7594', 'Brave Soul', '2023-08-02', 'C1111'),
('PR2871', 'Calm River', '2024-09-21', 'C4856'),
('PR5682', 'Strong Heart', '2024-09-22', 'C2164'),
('PR1935', 'Dreamy Voyager', '2023-11-05', 'C5792'),
('PR8124', 'Lone Wanderer', '2024-10-11', 'C2164'),
('PR3245', 'Gentle Spirit', '2024-10-12', 'C1111');

# Data for DEVICE
INSERT INTO DEVICE VALUES
('D1029', 'Television'),
('D3027', 'Smartphone'),
('D5903', 'Tablet'),
('D4789', 'Game Console'),
('D8734', 'Smartphone'),
('D2761', 'Television'),
('D3845', 'Tablet'),
('D5932', 'Game Console'),
('D4910', 'Television'),
('D6492', 'Smartphone'),
('D7348', 'Tablet'),
('D8164', 'Game Console'),
('D9213', 'Television'),
('D4329', 'Tablet'),
('D2743', 'Smartphone');

# Data for CUSTOMER_DEVICE
INSERT INTO CUSTOMER_DEVICE VALUES
('D1029', 'C4856', '2023-08-10'),
('D3027', 'C2164', '2023-05-18'),
('D5903', 'C3891', '2023-03-05'),
('D4789', 'C2164', '2023-11-30'),
('D8734', 'C6458', '2024-06-20'),
('D2761', 'C3489', '2024-05-05'),
('D3845', 'C5792', '2023-08-15'),
('D5932', 'C8593', '2024-03-20'),
('D4910', 'C9124', '2024-01-25'),
('D6492', 'C1111', '2023-07-25'),
('D7348', 'C2164', '2023-09-10'),
('D8164', 'C4856', '2024-04-05'),
('D9213', 'C1012', '2023-11-20'),
('D4329', 'C5792', '2024-05-15'),
('D2743', 'C1111', '2023-12-15');

# Data for GENRE
INSERT INTO GENRE VALUES
('G0001', 'Action'),
('G0002', 'Comedy'),
('G0003', 'Drama'),
('G0004', 'Fantasy'),
('G0005', 'Horror'),
('G0006', 'Romance'),
('G0007', 'Sci-Fi'),
('G0008', 'Thriller');

# Data for PREFERRED_GENRE
INSERT INTO PREFERRED_GENRE VALUES
('PR1201', 'G0001'),
('PR1201', 'G0003'),
('PR3427', 'G0002'),
('PR3427', 'G0004'),
('PR5932', 'G0005'),
('PR7649', 'G0006'),
('PR9812', 'G0007'),
('PR3058', 'G0008'),
('PR4875', 'G0001'),
('PR6781', 'G0003'),
('PR1345', 'G0005'),
('PR7594', 'G0006'),
('PR2871', 'G0002'),
('PR5682', 'G0004'),
('PR1935', 'G0007');

# Data for MEDIA
INSERT INTO MEDIA VALUES
('M0101', 'Galactic Odyssey', '2021-05-12', 8.7, 'Movie'),
('M0102', 'Comedy Central', '2019-08-15', 7.3, 'Series'),
('M0103', 'Haunting Shadows', '2022-10-31', 6.5, 'Movie'),
('M0104', 'The Lost World', '2020-06-10', 9.0, 'Series'),
('M0105', 'Love Forever', '2018-02-14', 8.0, 'Movie'),
('M0106', 'Adventure Awaits', '2023-01-01', 7.8, 'Series'),
('M0107', 'Fight Night', '2021-03-20', 6.0, 'Movie'),
('M0108', 'Mystery Road', '2019-11-21', 8.5, 'Series'),
('M0109', 'Scary Nights', '2020-10-31', 5.8, 'Movie'),
('M0110', 'Romantic Journey', '2022-09-15', 7.1, 'Series'),
('M0111', 'Sci-Fi Dreams', '2023-02-22', 8.2, 'Movie'),
('M0112', 'Thriller Night', '2021-12-12', 6.9, 'Series'),
('M0113', 'Fantasy Land', '2020-04-01', 9.2, 'Movie'),
('M0114', 'Epic Adventure', '2023-03-03', 8.1, 'Series'),
('M0115', 'Dramatic Turn', '2019-07-07', 7.4, 'Movie');

# Data for MEDIA_GENRE
INSERT INTO MEDIA_GENRE VALUES
('M0101', 'G0001'),
('M0101', 'G0004'),
('M0102', 'G0002'),
('M0103', 'G0005'),
('M0104', 'G0006'),
('M0105', 'G0003'),
('M0106', 'G0007'),
('M0107', 'G0008'),
('M0108', 'G0001'),
('M0109', 'G0002'),
('M0110', 'G0003'),
('M0111', 'G0005'),
('M0112', 'G0006'),
('M0113', 'G0007'),
('M0114', 'G0008'),
('M0115', 'G0001');

# Data for WATCH_RECORD
INSERT INTO WATCH_RECORD VALUES
('PR1201', 'D1029', 'M0101', '2024-01-02', '10:30:00', 120),
('PR3427', 'D5903', 'M0102', '2024-01-03', '15:45:00', 45),
('PR5932', 'D4789', 'M0103', '2024-01-05', '20:00:00', 90),
('PR7649', 'D3027', 'M0104', '2024-01-10', '18:00:00', 30),
('PR9812', 'D4910', 'M0105', '2024-01-12', '14:30:00', 60),
('PR3058', 'D6492', 'M0106', '2024-01-15', '21:00:00', 150),
('PR4875', 'D7348', 'M0107', '2024-01-20', '13:15:00', 75),
('PR6781', 'D8164', 'M0108', '2024-01-22', '19:00:00', 120),
('PR1345', 'D9213', 'M0109', '2024-01-25', '22:45:00', 40),
('PR7594', 'D4329', 'M0110', '2024-01-30', '17:30:00', 100),
('PR2871', 'D2761', 'M0111', '2024-02-01', '11:15:00', 80),
('PR5682', 'D3845', 'M0112', '2024-02-05', '16:00:00', 120),
('PR1935', 'D5903', 'M0113', '2024-02-10', '12:30:00', 60),
('PR8124', 'D4789', 'M0114', '2024-02-15', '14:45:00', 90),
('PR3245', 'D3027', 'M0115', '2024-02-20', '18:20:00', 150);

# Data for ACTOR
INSERT INTO ACTOR VALUES
('M0101', 'Tom Hanks'),
('M0101', 'Emma Watson'),
('M0102', 'Steve Carell'),
('M0102', 'Mindy Kaling'),
('M0102', 'B.J. Novak'),
('M0103', 'Natalie Portman'),
('M0104', 'Chris Pratt'),
('M0104', 'Zoe Saldana'),
('M0105', 'Ryan Gosling'),
('M0106', 'Jennifer Lawrence'),
('M0106', 'Josh Hutcherson'),
('M0107', 'Denzel Washington'),
('M0108', 'Katherine Langford'),
('M0109', 'Samuel L. Jackson'),
('M0110', 'Anne Hathaway'),
('M0111', 'Leonardo DiCaprio'),
('M0112', 'Viola Davis'),
('M0113', 'Margot Robbie'),
('M0114', 'Tom Hardy'),
('M0114', 'Charlize Theron'),
('M0115', 'Meryl Streep');

# Data for DIRECTOR
INSERT INTO DIRECTOR VALUES
('M0101', 'Steven Spielberg'),
('M0101', 'J.J. Abrams'),
('M0102', 'Greg Daniels'),
('M0103', 'Darren Aronofsky'),
('M0104', 'James Gunn'),
('M0105', 'Damien Chazelle'),
('M0106', 'Francis Lawrence'),
('M0107', 'Antoine Fuqua'),
('M0108', 'Jessica Yu'),
('M0109', 'Quentin Tarantino'),
('M0110', 'David O. Russell'),
('M0111', 'Martin Scorsese'),
('M0112', 'Ava DuVernay'),
('M0113', 'Gore Verbinski'),
('M0114', 'Ridley Scott'),
('M0115', 'Sofia Coppola');

# Data for MOVIE
INSERT INTO MOVIE VALUES
('M0101', 120),
('M0103', 95),
('M0105', 110),
('M0107', 80),
('M0109', 90),
('M0111', 130),
('M0113', 140),
('M0115', 100);

# Data for SERIES
INSERT INTO SERIES VALUES
('M0102', 'Pilot', 1, 1),
('M0104', 'The Lost World Begins', 1, 1),
('M0106', 'Adventure Awaits: The Beginning', 1, 1),
('M0108', 'Mystery Unfolds', 1, 1),
('M0110', 'A Romantic Beginning', 1, 1),
('M0112', 'Thriller Unraveled', 1, 1),
('M0114', 'Epic Journey', 1, 1);

#-----------------------------------------------------------------
# SECTION 3: QUERYING EXAMPLES
#-----------------------------------------------------------------

# Tester for Correct Database implementation, shows movies!
SELECT M1.MovieID, M2.Title, Run_Time
FROM movie M1, media M2
WHERE M1.MovieID=M2.MediaID;

# QUERY #1 : Consumer Analytics
SELECT P.ProfileID, P.PName AS Profile_Name, SUM(W.Watch_Duration) AS Total_Watch_Duration
FROM Profile P
INNER JOIN Watch_Record W ON P.ProfileID = W.ProfileID
GROUP BY P.ProfileID, P.PName
UNION ALL
SELECT 'Average Watch Duration' AS Metric, NULL AS Year, ROUND(AVG(w.Watch_Duration), 2) AS Value
FROM PROFILE p
INNER JOIN WATCH_RECORD w ON p.ProfileID = w.ProfileID;

# QUERY #2 : Customer Support
SELECT C.CustomerID, C.Full_Name, D.Device_Type, CD.Paired_Date
FROM Customer C
INNER JOIN Customer_Device CD ON C.CustomerID = CD.CustomerID
INNER JOIN Device D ON CD.DeviceID = D.DeviceID
WHERE C.CustomerID = 'C3891';

# QUERY #3 : Finance
SELECT  S.Subscription_Tier, SUM(P.Amount) AS Total_Revenue,
ROUND(SUM(P.Amount) / (SELECT SUM(Amount) FROM Payment) * 100, 2) AS Revenue_Percentage
FROM Payment P
INNER JOIN Subscription S 
ON P.SubscriptionID = S.SubscriptionID 
GROUP BY  S.Subscription_Tier;

# Query #4 : Preferred Genres by Percentage Share
SELECT genre_name as Genre, ROUND(COUNT(*) / (SELECT COUNT(profileid) FROM profile) * 100, 2) as 'Preferred by %:' 
FROM preferred_genre pg inner join genre g on g.genreid = pg.genreid 
GROUP BY Genre_name;
