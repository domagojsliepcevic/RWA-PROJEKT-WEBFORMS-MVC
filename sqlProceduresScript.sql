IF TYPE_ID(N'KeyList') IS NULL
	CREATE TYPE dbo.KeyList AS TABLE (
		[Key] int NOT NULL
		PRIMARY KEY ([Key])
	)
GO

IF TYPE_ID(N'PictureList') IS NULL
	CREATE TYPE dbo.PictureList AS TABLE (
		Id int NULL, 
		[Path] nvarchar(250) NULL, 
		[Name] nvarchar(250) NULL, 
		IsRepresentative bit NOT NULL, 
		DoDelete bit NOT NULL
	)
GO

CREATE OR ALTER PROCEDURE dbo.GetApartment
	@id int = null
AS

	SELECT 
		  a.Id,
		  a.[Guid],
		  a.CreatedAt,
		  DeletedAt,
		  OwnerId,
		  OwnerName = ao.[Name],
		  TypeId,
		  StatusId,
		  StatusName = ast.[Name],
		  CityId,
		  CityName = c.[Name],
		  [Address],
		  a.[Name],
		  a.NameEng,
		  Price,
		  MaxAdults,
		  MaxChildren,
		  TotalRooms,
		  BeachDistance
	FROM 
		dbo.Apartment a
		JOIN dbo.ApartmentOwner ao ON ao.Id = a.OwnerId
		JOIN dbo.ApartmentStatus ast ON ast.Id = a.StatusId
		JOIN dbo.City c ON c.Id = a.CityId
	WHERE a.Id = @id
GO

CREATE OR ALTER PROCEDURE dbo.GetApartmentTags
	@apartmentId int
AS
	SELECT 
		t.Id,
		t.[Name]
	FROM 
		dbo.TaggedApartment ta
		JOIN dbo.Tag t ON t.Id = ta.TagId
	WHERE ta.ApartmentId = @apartmentId
	ORDER BY t.[Name]
GO

CREATE OR ALTER PROCEDURE dbo.GetApartmentPictures
	@apartmentId int
AS
	SELECT 
		  Id,
		  [Guid],
		  [Name],
		  [Path],
		  IsRepresentative
	FROM dbo.ApartmentPicture
	WHERE ApartmentId = @apartmentId
	ORDER BY IsRepresentative DESC, [Name] ASC
GO

CREATE OR ALTER PROCEDURE dbo.CreateApartment
	@guid uniqueidentifier,
	@ownerId int,
	@typeId int,
	@statusId int,
	@cityId int,
	@address nvarchar(250),
	@name nvarchar(250),
	@price money,
	@maxAdults int,
	@maxChildren int,
	@totalRooms int,
	@beachDistance int,
	@tags KeyList READONLY,
	@pictures PictureList READONLY
AS

	
	DECLARE @Output KeyList
	DECLARE @ApartmentId int

	INSERT INTO dbo.Apartment(
		[Guid],
		CreatedAt,
		OwnerId,
		TypeId,
		StatusId,
		CityId,
		[Address],
		[Name],
		NameEng,
		Price,
		MaxAdults,
		MaxChildren,
		TotalRooms,
		BeachDistance)
	OUTPUT INSERTED.ID INTO @Output([Key])
    SELECT
		@guid,
		SYSUTCDATETIME(),
		@ownerId,
		@typeId,
		@statusId,
		@cityId,
		@address,
		@name,
		'',
		@price,
		@maxAdults,
		@maxChildren,
		@totalRooms,
		@beachDistance

	SELECT @ApartmentId = [Key]
	FROM @Output

	INSERT INTO dbo.TaggedApartment(
		ApartmentId,
		TagId)
	SELECT
		@ApartmentId,
		[Key]
	FROM @tags

	INSERT INTO dbo.ApartmentPicture(
		ApartmentId,
		[Path],
		[Name],
		IsRepresentative)
	SELECT
		@ApartmentId,
		[Path],
		[Name],
		IsRepresentative
	FROM @pictures

GO

CREATE OR ALTER PROCEDURE dbo.UpdateApartment
	@id int,
	@guid uniqueidentifier,
	@ownerId int,
	@typeId int,
	@statusId int,
	@cityId int,
	@address nvarchar(250),
	@name nvarchar(250),
	@price money,
	@maxAdults int,
	@maxChildren int,
	@totalRooms int,
	@beachDistance int,
	@tags KeyList READONLY,
	@pictures PictureList READONLY
AS

	
	DECLARE @Output KeyList

	UPDATE dbo.Apartment
	SET 
		[Guid] = @guid,
		OwnerId = @ownerId,
		TypeId = @typeId,
		StatusId = @statusId,
		CityId = @cityId,
		[Address] = @address,
		[Name] = @name,
		Price = @price,
		MaxAdults = @maxAdults,
		MaxChildren = @maxChildren,
		TotalRooms = @totalRooms,
		BeachDistance = @beachDistance
	WHERE id = @id

	MERGE dbo.TaggedApartment AS tgt
	USING @tags AS src
	ON (tgt.Id = src.[Key]) 
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (ApartmentId, TagId)
		VALUES (@id, [Key])
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE;

	MERGE dbo.ApartmentPicture AS tgt
	USING @pictures AS src
	ON (tgt.Id = src.Id) 
	WHEN MATCHED THEN
		UPDATE SET 
			[Name] = src.[Name],
			IsRepresentative = src.IsRepresentative
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (ApartmentId, [Path], [Name], IsRepresentative)
		VALUES (@id, [Path], [Name], IsRepresentative)
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE;

GO

CREATE OR ALTER PROCEDURE dbo.DeleteApartment
	@id int
AS
	UPDATE dbo.Apartment
	SET DeletedAt = SYSUTCDATETIME()
	WHERE Id = @id
GO

CREATE OR ALTER PROCEDURE dbo.GetApartments
	@statusId int = null,
	@cityId int = null,
	@order int = null
AS
	SELECT 
		  a.Id,
		  a.[Guid],
		  a.CreatedAt,
		  DeletedAt,
		  OwnerId,
		  OwnerName = ao.[Name],
		  TypeId,
		  StatusId,
		  StatusName = ast.[Name],
		  CityId,
		  CityName = c.[Name],
		  [Address],
		  a.[Name],
		  a.NameEng,
		  Price,
		  MaxAdults,
		  MaxChildren,
		  TotalRooms,
		  BeachDistance
	FROM 
		dbo.Apartment a
		JOIN dbo.ApartmentOwner ao ON ao.Id = a.OwnerId
		JOIN dbo.ApartmentStatus ast ON ast.Id = a.StatusId
		JOIN dbo.City c ON c.Id = a.CityId
	WHERE
		(@statusId IS NULL OR @statusId IS NOT NULL AND StatusId = @statusId)
		AND
		(@cityId IS NULL OR @cityId IS NOT NULL AND CityId = @cityId)
		AND
		DeletedAt IS NULL
	ORDER BY 
        CASE
            WHEN @order is null THEN a.Id
            WHEN @order = 1 THEN TotalRooms
            WHEN @order = 2 THEN MaxAdults
            WHEN @order = 3 THEN MaxChildren
            WHEN @order = 4 THEN Price
        END
GO

CREATE OR ALTER PROCEDURE dbo.GetCities
AS
	SELECT 
		  Id,
		  [Guid],
		  [Name]
	FROM dbo.City
	ORDER BY [Name]
GO

CREATE OR ALTER PROCEDURE dbo.GetTags
AS
	SELECT 
		  Id,
		  [Guid],
		  [Name]
	FROM dbo.Tag
	ORDER BY [Name]
GO

CREATE OR ALTER PROCEDURE dbo.GetApartmentOwners
AS
	SELECT 
		  Id,
		  [Guid],
		  [Name]
	FROM dbo.ApartmentOwner
	ORDER BY [Name]
GO

CREATE OR ALTER PROCEDURE dbo.GetUsers
AS
BEGIN
	SELECT
	*
	FROM dbo.AspNetUsers
	where dbo.AspNetUsers.DeletedAt is null
END
GO

CREATE OR ALTER PROC dbo.InsertTag
	@TypeId int,
	@Name nvarchar(50),
	@nameEng nvarchar(50)
AS
BEGIN
	INSERT INTO Tag (Guid,CreatedAt,TypeId,Name,NameEng) values(NEWID(),GETDATE(),@TypeId,@Name,@nameEng)
END
GO

CREATE OR ALTER PROC dbo.DeleteTag
	@id int
AS
BEGIN
	DELETE 
	FROM Tag
	WHERE @id = Tag.Id
END
GO

CREATE OR ALTER PROC dbo.GetTagTypes
AS
BEGIN
SELECT
*
FROM TagType
END
GO

CREATE OR ALTER PROC dbo.GetTagCount
AS
BEGIN
SELECT t.Id,t.Name,COUNT(ta.TagId) as Total from Tag as t
left outer join TaggedApartment ta on ta.TagId = t.Id
GROUP BY t.Id,t.Name, ta.TagId
ORDER BY Total desc
END
GO

CREATE OR ALTER proc dbo.AuthUser
	@email nvarchar(70),
	@PasswordHash nvarchar(max)
AS
BEGIN
	SELECT
	* 
	FROM AspNetUsers 
	WHERE Email=@email and PasswordHash=@PasswordHash and DeletedAt is null
END
GO

CREATE OR ALTER PROC dbo.AuthAdmin
	@email nvarchar(70),
	@PasswordHash nvarchar(max)
AS
	BEGIN
	SELECT
	* 
	FROM AspNetUsers 
	inner join AspNetUserRoles on AspNetUserRoles.UserId = AspNetUsers.Id
	WHERE Email=@email and PasswordHash=@PasswordHash and AspNetUserRoles.RoleId = 1

END
GO

CREATE OR ALTER PROC dbo.CreateUser
	@Email nvarchar(100),
	@Passwordhash nvarchar(max),
	@PhoneNumber nvarchar(100),
	@UserName nvarchar(250),
	@Address nvarchar(1000)
AS
BEGIN
IF not exists
(SELECT*FROM AspNetUsers WHERE Email=@Email and PasswordHash = @Passwordhash)
INSERT INTO AspNetUsers(Guid,CreatedAt,Email,EmailConfirmed,PasswordHash,PhoneNumber,PhoneNumberConfirmed,LockoutEnabled,AccessFailedCount,UserName,Address)
VALUES(NEWID(),GETDATE(),@Email,1,@Passwordhash,@PhoneNumber,1,0,0,@UserName,@Address)
END
GO


CREATE OR ALTER PROCEDURE SearchApartments
	@rooms int = null,
	@adults int = null,
	@children int = null,
	@destination int = null,
	@order int = null
AS

	SELECT
		a.Id,
		a.[Name],
		StarRating = (
			SELECT avg(Stars) 
			FROM ApartmentReview ar 
			WHERE ar.ApartmentId = a.Id),
		CityName = c.[Name],
		BeachDistance,
		TotalRooms,
		MaxAdults,
		MaxChildren,
		Price,
		RepresentativePicturePath = (
			SELECT TOP 1 ap.[Path]
			FROM dbo.ApartmentPicture ap
			WHERE ap.ApartmentId = a.Id
			ORDER BY ap.IsRepresentative DESC, Id)			
		--TagId = t.Id,
		--TagName = t.[Name]
	FROM 
		dbo.Apartment a
		LEFT JOIN City c ON c.Id = a.CityId
		LEFT JOIN dbo.ApartmentPicture ap ON ap.ApartmentId = a.Id
		--JOIN TaggedApartment ta ON ta.ApartmentId = a.Id
		--JOIN Tag t ON t.Id = ta.TagId
	WHERE 
		(@rooms IS NULL OR @rooms IS NOT NULL AND a.TotalRooms >= @rooms)
		AND 
		(@adults IS NULL OR @adults IS NOT NULL AND a.MaxAdults >= @adults)
		AND 
		(@children IS NULL OR @children IS NOT NULL AND a.MaxChildren >= @children)
		AND 
		(@destination IS NULL OR @destination IS NOT NULL AND a.CityId = @destination)
		AND
		ap.DeletedAt IS NULL
	ORDER BY 
        CASE
            WHEN @order is null THEN a.Id
            WHEN @order = 1 THEN TotalRooms
            WHEN @order = 2 THEN MaxAdults
            WHEN @order = 3 THEN MaxChildren
            WHEN @order = 4 THEN Price
        END
GO

CREATE OR ALTER PROCEDURE dbo.GetPublicApartment
	@id int = null
AS

	SELECT 
		a.Id,
		a.[Name],
		StarRating = (
			SELECT avg(Stars) 
			FROM ApartmentReview ar 
			WHERE ar.ApartmentId = a.Id),
		CityName = c.[Name],
		BeachDistance,
		TotalRooms,
		MaxAdults,
		MaxChildren,
		OwnerName = ao.[Name]
	FROM 
		dbo.Apartment a
		LEFT JOIN dbo.ApartmentOwner ao ON ao.Id = a.OwnerId
		LEFT JOIN dbo.City c ON c.Id = a.CityId
	WHERE a.Id = @id and a.DeletedAt is null
GO

CREATE OR ALTER PROCEDURE dbo.GetPublicApartmentTags
	@apartmentId int = null
AS

	SELECT 
	t.[Name] 
	FROM dbo.TaggedApartment as ta
	inner join dbo.Apartment as a on a.Id=ta.ApartmentId
	inner join dbo.Tag as t on t.Id=ta.TagId
	WHERE ta.ApartmentId= @apartmentId and a.DeletedAt is null
GO

CREATE OR ALTER PROCEDURE dbo.GetPublicApartmentPictures
	@apartmentId int = null
AS

	SELECT 
		ap.Id,
		ap.[Name],
		ap.[Path],
		ap.IsRepresentative
	FROM 
		dbo.Apartment a
		JOIN dbo.ApartmentPicture ap ON ap.ApartmentId = a.Id
	WHERE a.Id = @apartmentId and a.DeletedAt is null
GO