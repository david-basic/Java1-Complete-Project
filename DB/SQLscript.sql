CREATE DATABASE Java1Projekt
GO

USE Java1Projekt
GO



-- Roles and insertion of two only roles in the app
CREATE TABLE Roles
(  
    IDRole INT PRIMARY KEY IDENTITY,
    RoleName NVARCHAR(50)
)
GO
INSERT INTO Roles VALUES('admin')
GO
INSERT INTO Roles VALUES('user')
GO




-- creation of Users table, procedures for creating admin and CRUD for users
CREATE TABLE Users
(
    IDUser INT PRIMARY KEY IDENTITY,
    Nickname NVARCHAR(300) NOT NULL,
    Username NVARCHAR(300) NOT NULL,
    UserPassword NVARCHAR(300) NOT NULL,
    RoleID INT FOREIGN KEY REFERENCES Roles(IDRole) NOT NULL
)
GO

CREATE PROCEDURE createAdmin
	@IDUser INT OUTPUT
AS
BEGIN
	INSERT INTO Users VALUES('Administrator', 'admin', 'admin123', 1)
	SET @IDUser = SCOPE_IDENTITY()
END
GO

CREATE PROCEDURE createUser
    @Nickname NVARCHAR(300),
    @Username NVARCHAR(300),
    @UserPassword NVARCHAR(300),
	@RoleID INT,
	@IDUser INT OUTPUT
AS
BEGIN
    INSERT INTO Users VALUES(@Nickname, @Username, @UserPassword, @RoleID)
	SET @IDUser = SCOPE_IDENTITY()
END
GO

CREATE PROCEDURE selectUser
	@IDUser INT
AS
BEGIN
	SELECT *
	FROM Users
	WHERE IDUser = @IDUser
END
GO

CREATE PROCEDURE deleteUser
	@IDUser INT
AS
BEGIN
	DELETE
	FROM Users
	WHERE IDUser = @IDUser
END
GO

CREATE PROCEDURE selectUsers
AS
BEGIN
	SELECT *
	FROM Users
END
GO




-- movie roles creation and insertion
CREATE TABLE MovieRoles
(
	IDMovieRole INT PRIMARY KEY IDENTITY,
	RoleName NVARCHAR(50)
)
GO
INSERT INTO MovieRoles VALUES('Actor')
GO
INSERT INTO MovieRoles VALUES('Director')
GO




-- Employee table and CRUD procedures
CREATE TABLE Employee
(
	IDEmployee INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	MovieRoleID INT FOREIGN KEY REFERENCES MovieRoles(IDMovieRole) NOT NULL,
	PicturePath NVARCHAR(200) NOT NULL
)
GO

CREATE PROCEDURE createEmployee
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50),
	@MovieRoleID INT,
	@PicturePath NVARCHAR(200),
	@IDEmployee INT OUTPUT
AS
BEGIN
	INSERT INTO Employee VALUES(@FirstName, @LastName, @MovieRoleID, @PicturePath)
	SET @IDEmployee = SCOPE_IDENTITY()
END
GO

CREATE PROCEDURE selectEmployee
	@IDEmployee INT
AS
BEGIN
	SELECT * 
	FROM Employee
	WHERE IDEmployee = @IDEmployee
END
GO

CREATE PROCEDURE updateEmployee
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50),
	@MovieRoleID INT,
	@PicturePath NVARCHAR(200),
	@IDEmployee INT
AS
BEGIN
	UPDATE Employee
	SET
		FirstName = @FirstName,
		LastName = @LastName,
		MovieRoleID = @MovieRoleID,
		PicturePath = @PicturePath
	WHERE
		IDEmployee = @IDEmployee
END
GO

CREATE PROCEDURE deleteEmployee
	@IDEmployee INT
AS
BEGIN
	DELETE
	FROM Employee
	WHERE IDEmployee = @IDEmployee
END
GO

CREATE PROCEDURE selectEmployees
AS
BEGIN
	SELECT *
	FROM Employee
END
GO




-- Movie table and CRUD procedures
CREATE TABLE Movie
(
	IDMovie INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(200) NOT NULL,
	Genre NVARCHAR(200) NOT NULL,
	YearPublished INT NOT NULL,
	Duration INT NOT NULL,
	MovieDescription NVARCHAR(MAX) NOT NULL,
	Link NVARCHAR(MAX) NOT NULL,
	PicturePath NVARCHAR(200) NOT NULL
)
GO

CREATE PROCEDURE createMovie
	@Title NVARCHAR(200),
	@Genre NVARCHAR(200),
	@YearPublished INT,
	@Duration INT,
	@MovieDescription NVARCHAR(MAX),
	@Link NVARCHAR(MAX),
	@PicturePath NVARCHAR(200),
	@IDMovie INT OUTPUT
AS
BEGIN
	INSERT INTO Movie VALUES(@Title, @Genre, @YearPublished, @Duration, @MovieDescription, @Link, @PicturePath)
	SET @IDMovie = SCOPE_IDENTITY()
END
GO

CREATE PROCEDURE selectMovie
	@IDMovie INT
AS
BEGIN
	SELECT * 
	FROM Movie
	WHERE IDMovie = @IDMovie
END
GO

CREATE PROCEDURE updateMovie
	@Title NVARCHAR(200),
	@Genre NVARCHAR(200),
	@YearPublished INT,
	@Duration INT,
	@MovieDescription NVARCHAR(MAX),
	@Link NVARCHAR(MAX),
	@PicturePath NVARCHAR(200),
	@IDMovie INT
AS
BEGIN
	UPDATE Movie
	SET
		Title = @Title,
		Genre = @Genre,
		YearPublished = @YearPublished,
		Duration = @Duration,
		MovieDescription = @MovieDescription,
		Link = @Link,
		PicturePath = @PicturePath
	WHERE
		IDMovie = @IDMovie
END
GO

CREATE PROCEDURE deleteMovie
	@IDMovie INT
AS
BEGIN
	DELETE
	FROM Movie
	WHERE IDMovie = @IDMovie
END
GO

CREATE PROCEDURE selectMovies
AS
BEGIN
	SELECT *
	FROM Movie
END
GO




-- posredna tablica za Movie-Actor
CREATE TABLE MovieCast
(
	IDMovieCast INT PRIMARY KEY IDENTITY,
	EmployeeID INT FOREIGN KEY REFERENCES Employee(IDEmployee),
	MovieID INT FOREIGN KEY REFERENCES Movie(IDMovie)
)
GO

CREATE PROCEDURE addActorToMovie
	@IDEmployee INT,
	@IDMovie INT
AS
BEGIN
	INSERT INTO MovieCast VALUES(@IDEmployee, @IDMovie)
END
GO

CREATE PROCEDURE deleteActorFromMovie
	@IDEmployee INT,
	@IDMovie INT
AS
BEGIN
	DELETE
	FROM MovieCast
	WHERE EmployeeID = @IDEmployee AND MovieID = @IDMovie
END
GO

CREATE PROCEDURE deleteActorFromAllMovies
	@IDEmployee INT
AS
BEGIN
	DELETE
	FROM MovieCast
	WHERE EmployeeID = @IDEmployee
END
GO

CREATE PROCEDURE selectAllMoviesOfActor
	@IDEmployee INT
AS
BEGIN
	SELECT m.*
	FROM Movie as m
	INNER JOIN MovieCast as mc on mc.MovieID = m.IDMovie
	INNER JOIN Employee as e on e.IDEmployee = mc.EmployeeID
	WHERE mc.EmployeeID = @IDEmployee
END
GO

CREATE PROCEDURE selectAllActorsOnMovie
	@IDMovie INT
AS
BEGIN
	SELECT e.*
	FROM Employee as e
	INNER JOIN MovieCast as mc on mc.EmployeeID = e.IDEmployee
	INNER JOIN Movie as m on m.IDMovie = mc.MovieID
	WHERE mc.MovieID = @IDMovie
END
GO

CREATE PROCEDURE deleteMovieWithActor
	@IDMovie INT,
	@IDEmployee INT
AS
BEGIN
	DELETE
	FROM MovieCast
	WHERE MovieID = @IDMovie AND EmployeeID = @IDEmployee
END
GO




-- posredna tablica za Movie-Director
CREATE TABLE MovieDirection
(
	IDMovieDirection INT PRIMARY KEY IDENTITY,
	EmployeeID INT FOREIGN KEY REFERENCES Employee(IDEmployee),
	MovieID INT FOREIGN KEY REFERENCES Movie(IDMovie)
)
GO

CREATE PROCEDURE addDirectorToMovie
	@IDEmployee INT,
	@IDMovie INT
AS
BEGIN
	INSERT INTO MovieDirection VALUES(@IDEmployee, @IDMovie)
END
GO

CREATE PROCEDURE deleteDirectorFromMovie
	@IDEmployee INT,
	@IDMovie INT
AS
BEGIN
	DELETE
	FROM MovieDirection
	WHERE EmployeeID = @IDEmployee AND MovieID = @IDMovie
END
GO

CREATE PROCEDURE deleteDirectorFromAllMovies
	@IDEmployee INT
AS
BEGIN
	DELETE
	FROM MovieDirection
	WHERE EmployeeID = @IDEmployee
END
GO

CREATE PROCEDURE selectAllMoviesOfDirector
	@IDEmployee INT
AS
BEGIN
	SELECT m.*
	FROM Movie as m
	INNER JOIN MovieDirection as md on md.MovieID = m.IDMovie
	INNER JOIN Employee as e on e.IDEmployee = md.EmployeeID
	WHERE md.EmployeeID = @IDEmployee
END
GO

CREATE PROCEDURE selectAllDirectorsOnMovie
	@IDMovie INT
AS
BEGIN
	SELECT e.*
	FROM Employee as e
	INNER JOIN MovieDirection as md on md.EmployeeID = e.IDEmployee
	INNER JOIN Movie as m on m.IDMovie = md.MovieID
	WHERE md.MovieID = @IDMovie
END
GO

CREATE PROCEDURE deleteMovieWithDirector
	@IDMovie INT,
	@IDEmployee INT
AS
BEGIN
	DELETE
	FROM MovieDirection
	WHERE MovieID = @IDMovie AND EmployeeID = @IDEmployee
END
GO




-- all tables wipe except users and roles
CREATE PROCEDURE wipeAllData
AS
BEGIN
	DELETE
	FROM MovieCast
	DELETE
	FROM MovieDirection
	DELETE
	FROM Movie
	DELETE
	FROM Employee
	DBCC CHECKIDENT ('MovieCast', RESEED, 0);
	DBCC CHECKIDENT ('MovieDirection', RESEED, 0);
	DBCC CHECKIDENT ('Movie', RESEED, 0);
	DBCC CHECKIDENT ('Employee', RESEED, 0);
END