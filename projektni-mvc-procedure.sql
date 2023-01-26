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
	WHERE a.Id = @id
GO

CREATE OR ALTER PROCEDURE dbo.GetPublicApartmentTags
	@apartmentId int = null
AS

	SELECT 
		t.[Name]
	FROM 
		dbo.Apartment a
		JOIN dbo.TaggedApartment ta ON ta.ApartmentId = a.Id
		JOIN dbo.Tag t ON t.Id = ta.ApartmentId
	WHERE a.Id = @apartmentId
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
	WHERE a.Id = @apartmentId
GO
