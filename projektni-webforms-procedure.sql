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
