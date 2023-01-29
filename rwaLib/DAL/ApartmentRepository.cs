using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using Microsoft.ApplicationBlocks.Data;
using System.Data;
using System.Data.SqlClient;
using rwaLib.Models;
using rwaLib.Models.ViewModels;

namespace rwaLib.DAL
{
    public class ApartmentRepository
    {
        private readonly string _connectionString;
        public ApartmentRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["rwadb"].ConnectionString;
        }
        public List<Apartment> GetApartments(int? statusId, int? cityId, int? order)
        {
            var commandParameters = new List<SqlParameter>();
            if (statusId.HasValue && statusId.Value != 0)
                commandParameters.Add(new SqlParameter("@statusId", statusId));
            if (cityId.HasValue && cityId.Value != 0)
                commandParameters.Add(new SqlParameter("@cityId", cityId));
            if (order.HasValue && order.Value != 0)
                commandParameters.Add(new SqlParameter("@order", order));
            var ds = SqlHelper.ExecuteDataset(
             _connectionString,
             CommandType.StoredProcedure,
             "dbo.GetApartments",
             commandParameters.ToArray());
            var apList = new List<Apartment>();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                var ap = new Apartment();
                ap.Id = Convert.ToInt32(row["ID"]);
                ap.Guid = Guid.Parse(row["Guid"].ToString());
                ap.CreatedAt = Convert.ToDateTime(row["CreatedAt"]);
                ap.DeletedAt =
                row["DeletedAt"] != DBNull.Value ?
                (DateTime?)Convert.ToDateTime(row["DeletedAt"]) :
                null;
                ap.OwnerId = Convert.ToInt32(row["OwnerId"]);
                ap.OwnerName = row["OwnerName"].ToString();
                ap.TypeId = Convert.ToInt32(row["TypeId"]);
                ap.StatusId = Convert.ToInt32(row["StatusId"]);
                ap.StatusName = row["StatusName"].ToString();
                ap.CityId =
                row["CityId"] != DBNull.Value ?
                (int?)Convert.ToInt32(row["CityId"]) :
                null;
                ap.CityName = row["CityName"]?.ToString();
                ap.Address = row["Address"].ToString();
                ap.Name = row["Name"].ToString();
                ap.Price = Convert.ToDecimal(row["Price"]);
                ap.MaxAdults =
                row["MaxAdults"] != DBNull.Value ?
                (int?)Convert.ToInt32(row["MaxAdults"]) :
                null;
                ap.MaxChildren =
                row["MaxChildren"] != DBNull.Value ?
                (int?)Convert.ToInt32(row["MaxChildren"]) :
                null;
                ap.TotalRooms =
                row["TotalRooms"] != DBNull.Value ?
                (int?)Convert.ToInt32(row["TotalRooms"]) :
                null;
                ap.BeachDistance =
                row["BeachDistance"] != DBNull.Value ?
                (int?)Convert.ToInt32(row["BeachDistance"]) :
                null;
                apList.Add(ap);
            }
            return apList;
        }


        public void CreateApartment(Apartment apartment)
        {
            var commandParameters = new List<SqlParameter>();
            commandParameters.Add(new SqlParameter("@guid", apartment.Guid));
            commandParameters.Add(new SqlParameter("@ownerId", apartment.OwnerId));
            commandParameters.Add(new SqlParameter("@typeId", apartment.TypeId));
            commandParameters.Add(new SqlParameter("@statusId", apartment.StatusId));
            commandParameters.Add(new SqlParameter("@cityId", apartment.CityId));
            commandParameters.Add(new SqlParameter("@address", apartment.Address));
            commandParameters.Add(new SqlParameter("@name", apartment.Name));
            commandParameters.Add(new SqlParameter("@price", apartment.Price));
            commandParameters.Add(new SqlParameter("@maxAdults", apartment.MaxAdults));
            commandParameters.Add(new SqlParameter("@maxChildren", apartment.MaxChildren));
            commandParameters.Add(new SqlParameter("@totalRooms", apartment.TotalRooms));
            commandParameters.Add(new SqlParameter("@beachDistance", apartment.BeachDistance));

            DataTable dtTags = new DataTable();
            dtTags.Columns.AddRange(
            new DataColumn[1] {
            new DataColumn("Key", typeof(int)) });
            foreach (var tag in apartment.Tags)
                dtTags.Rows.Add(tag.Id);
            commandParameters.Add(new SqlParameter("@tags", dtTags));


            DataTable dtPics = new DataTable();
            dtPics.Columns.AddRange(
                new DataColumn[] {
                                  new DataColumn("Id", typeof(int)),
                                  new DataColumn("Path", typeof(string)),
                                  new DataColumn("Name", typeof(string)),
                                  new DataColumn("IsRepresentative", typeof(bool)),
                                  new DataColumn("DoDelete", typeof(bool)),
                                   });

            foreach (var apartmentPicture in apartment.ApartmentPictures)
            {
                if (!apartmentPicture.DoDelete)
                {
                    dtPics.Rows.Add(
                        apartmentPicture.Id,
                        apartmentPicture.Path,
                        apartmentPicture.Name,
                        apartmentPicture.IsRepresentative,
                        apartmentPicture.DoDelete);
                }
            }

            commandParameters.Add(new SqlParameter("@pictures", dtPics));


            SqlHelper.ExecuteNonQuery(
            _connectionString,
            CommandType.StoredProcedure,
            "dbo.CreateApartment",
            commandParameters.ToArray());

        }

        public Apartment GetApartment(int id)
        {
            var commandParameters = new List<SqlParameter>();
            commandParameters.Add(new SqlParameter("@id", id));
            var ds = SqlHelper.ExecuteDataset(
            _connectionString,
            CommandType.StoredProcedure,
            "dbo.GetApartment",
            commandParameters.ToArray());
            var row = ds.Tables[0].Rows[0];
            var ap = new Apartment();
            ap.Id = Convert.ToInt32(row["ID"]);
            ap.Guid = Guid.Parse(row["Guid"].ToString());
            ap.CreatedAt = Convert.ToDateTime(row["CreatedAt"]);
            ap.DeletedAt =
            row["DeletedAt"] != DBNull.Value ?
            (DateTime?)Convert.ToDateTime(row["DeletedAt"]) :
            null;
            ap.OwnerId = Convert.ToInt32(row["OwnerId"]);
            ap.OwnerName = row["OwnerName"].ToString();
            ap.TypeId = Convert.ToInt32(row["TypeId"]);
            ap.StatusId = Convert.ToInt32(row["StatusId"]);
            ap.StatusName = row["StatusName"].ToString();
            ap.CityId =
            row["CityId"] != DBNull.Value ?
            (int?)Convert.ToInt32(row["CityId"]) :
            null;
            ap.CityName = row["CityName"]?.ToString();
            ap.Address = row["Address"].ToString();
            ap.Name = row["Name"].ToString();
            ap.Price = Convert.ToDecimal(row["Price"]);
            ap.MaxAdults =
            row["MaxAdults"] != DBNull.Value ?
            (int?)Convert.ToInt32(row["MaxAdults"]) :
            null;
            ap.MaxChildren =
            row["MaxChildren"] != DBNull.Value ?
            (int?)Convert.ToInt32(row["MaxChildren"]) :
            null;
            ap.TotalRooms =
            row["TotalRooms"] != DBNull.Value ?
            (int?)Convert.ToInt32(row["TotalRooms"]) :
            null;
            ap.BeachDistance =
            row["BeachDistance"] != DBNull.Value ?
            (int?)Convert.ToInt32(row["BeachDistance"]) :
            null;
            return ap;
        }

        public List<Tag> GetApartmentTags(int apartmentId)
        {
            var commandParameters = new List<SqlParameter>();
            commandParameters.Add(new SqlParameter("@apartmentId", apartmentId));
            var ds = SqlHelper.ExecuteDataset(
            _connectionString,
            CommandType.StoredProcedure,
            "dbo.GetApartmentTags",
            commandParameters.ToArray());
            var tags = new List<Tag>();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                tags.Add(new Tag
                {
                    Id = Convert.ToInt32(row["Id"]),
                    Name = row["Name"].ToString(),
                });
            }
            return tags;
        }
        public void UpdateApartment(Apartment apartment)
        {
            var commandParameters = new List<SqlParameter>();
            commandParameters.Add(new SqlParameter("@id", apartment.Id));
            commandParameters.Add(new SqlParameter("@guid", apartment.Guid));
            commandParameters.Add(new SqlParameter("@ownerId", apartment.OwnerId));
            commandParameters.Add(new SqlParameter("@typeId", apartment.TypeId));
            commandParameters.Add(new SqlParameter("@statusId", apartment.StatusId));
            commandParameters.Add(new SqlParameter("@cityId", apartment.CityId));
            commandParameters.Add(new SqlParameter("@address", apartment.Address));
            commandParameters.Add(new SqlParameter("@name", apartment.Name));
            commandParameters.Add(new SqlParameter("@price", apartment.Price));
            commandParameters.Add(new SqlParameter("@maxAdults", apartment.MaxAdults));
            commandParameters.Add(new SqlParameter("@maxChildren", apartment.MaxChildren));
            commandParameters.Add(new SqlParameter("@totalRooms", apartment.TotalRooms));
            commandParameters.Add(new SqlParameter("@beachDistance", apartment.BeachDistance));

            DataTable dtTags = new DataTable();
            dtTags.Columns.AddRange(
            new DataColumn[1] {
            new DataColumn("Key", typeof(int)) });
            foreach (var tag in apartment.Tags)
                dtTags.Rows.Add(tag.Id);
            commandParameters.Add(new SqlParameter("@tags", dtTags));

            DataTable dtPics = new DataTable();
            dtPics.Columns.AddRange(
                new DataColumn[] {
            new DataColumn("Id", typeof(int)),
            new DataColumn("Path", typeof(string)),
            new DataColumn("Name", typeof(string)),
            new DataColumn("IsRepresentative", typeof(bool)),
            new DataColumn("DoDelete", typeof(bool)),
                });

            foreach (var apartmentPicture in apartment.ApartmentPictures)
            {
                if (!apartmentPicture.DoDelete)
                {
                    dtPics.Rows.Add(
                        apartmentPicture.Id,
                        apartmentPicture.Path,
                        apartmentPicture.Name,
                        apartmentPicture.IsRepresentative,
                        apartmentPicture.DoDelete);
                }
            }

            commandParameters.Add(new SqlParameter("@pictures", dtPics));

            SqlHelper.ExecuteNonQuery(
            _connectionString,
            CommandType.StoredProcedure,
            "dbo.UpdateApartment",
            commandParameters.ToArray());
        }
        public List<ApartmentPicture> GetApartmentPictures(int apartmentId)
        {
            var commandParameters = new List<SqlParameter>();
            commandParameters.Add(new SqlParameter("@apartmentId", apartmentId));
            var ds = SqlHelper.ExecuteDataset(
            _connectionString,
            CommandType.StoredProcedure,
            "dbo.GetApartmentPictures",
            commandParameters.ToArray());
            var pics = new List<ApartmentPicture>();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                pics.Add(new ApartmentPicture
                {
                    Id = Convert.ToInt32(row["Id"]),
                    Path = row["Path"].ToString(),
                    Name = row["Name"].ToString(),
                    IsRepresentative = bool.Parse(row["IsRepresentative"].ToString())
                });
            }
            return pics;
        }

        public void DeleteApartment(int id)
        {
            var commandParameters = new List<SqlParameter>();
            commandParameters.Add(new SqlParameter("@id", id));
            SqlHelper.ExecuteNonQuery(
            _connectionString,
            CommandType.StoredProcedure,
            "dbo.DeleteApartment",
            commandParameters.ToArray());
        }

        public List<SearchResultModel> Search(
          int? rooms,
          int? adults,
          int? children,
          int? destination,
          int? order)
        {
            if (destination == 0)
            {
                destination = null;
            }
            if(order == 0)
            { 
                order = null; 
            }
            var commandParameters = new List<SqlParameter>();
            commandParameters.Add(new SqlParameter("@rooms",rooms));
            commandParameters.Add(new SqlParameter("@adults",adults));
            commandParameters.Add(new SqlParameter("@children",children));
            commandParameters.Add(new SqlParameter("@destination",destination));
            commandParameters.Add(new SqlParameter("@order",order));
            
  
            var ds = SqlHelper.ExecuteDataset(
              _connectionString,
              CommandType.StoredProcedure,
              "dbo.SearchApartments",
              commandParameters.ToArray());

                var resList = new List<SearchResultModel>();
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    var ap = new SearchResultModel();
                    ap.Id = Convert.ToInt32(row["Id"]);
                    ap.Name = row["Name"].ToString();
                    if(!Convert.IsDBNull(row["StarRating"]))
                    { 
                        ap.StarRating = Convert.ToInt32(row["StarRating"]); 
                     }
                
                    ap.CityName = row["CityName"].ToString();
                    ap.BeachDistance = Convert.ToInt32(row["BeachDistance"]);
                    ap.TotalRooms = Convert.ToInt32(row["TotalRooms"]);
                    ap.MaxAdults = Convert.ToInt32(row["MaxAdults"]);
                    ap.MaxChildren = Convert.ToInt32(row["MaxChildren"]);
                    ap.Price = Convert.ToInt32(row["Price"]);
                    ap.RepresentativePicturePath = row["RepresentativePicturePath"].ToString();


                

                    resList.Add(ap);
                    }

                    return resList;
                }
        public PublicApartment GetPublicApartment(int id)
        {
            var commandParameters = new List<SqlParameter>();
            commandParameters.Add(new SqlParameter("@id", id));
            var ds = SqlHelper.ExecuteDataset(
            _connectionString,
            CommandType.StoredProcedure,
            "dbo.GetPublicApartment",
            commandParameters.ToArray());
            var row = ds.Tables[0].Rows[0];
            var ap = new PublicApartment();
            ap.Id = Convert.ToInt32(row["ID"]);
            ap.Name = row["Name"].ToString();
            ap.StarRating = row["StarRating"] != DBNull.Value ? (int?)Convert.ToInt32(row["StarRating"]) : null;
            ap.CityName = row["CityName"]?.ToString();
            ap.OwnerName = row["OwnerName"].ToString();
            ap.BeachDistance = row["BeachDistance"] != DBNull.Value ? (int?)Convert.ToInt32(row["BeachDistance"]) : null;
            ap.TotalRooms = row["TotalRooms"] != DBNull.Value ? (int?)Convert.ToInt32(row["TotalRooms"]) : null;
            ap.MaxAdults = row["MaxAdults"] != DBNull.Value ? (int?)Convert.ToInt32(row["MaxAdults"]) : null;
            ap.MaxChildren = row["MaxChildren"] != DBNull.Value ? (int?)Convert.ToInt32(row["MaxChildren"]) : null;
            ap.TotalRooms = row["TotalRooms"] != DBNull.Value ?(int?)Convert.ToInt32(row["TotalRooms"]) :null;
          
            return ap;
        }
        public List<Tag> GetPublicApartmentTags(int id)
        {
            var commandParameters = new List<SqlParameter>();
            commandParameters.Add(new SqlParameter("@apartmentId", id));
            var ds = SqlHelper.ExecuteDataset(
            _connectionString,
            CommandType.StoredProcedure,
            "dbo.GetPublicApartmentTags",
            commandParameters.ToArray());

            var tags = new List<Tag>();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                tags.Add(new Tag
                {
                  
                    Name = row["Name"].ToString(),
                   
                });
            }
            return tags;
        }

        public List<ApartmentPicture> GetPublicApartmentPictures(int id)
        {
            var commandParameters = new List<SqlParameter>();
            commandParameters.Add(new SqlParameter("@apartmentId", id));
            var ds = SqlHelper.ExecuteDataset(
            _connectionString,
            CommandType.StoredProcedure,
            "dbo.GetPublicApartmentPictures",
            commandParameters.ToArray());

            var pictures = new List<ApartmentPicture>();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                pictures.Add(new ApartmentPicture
                {

                    Id = Convert.ToInt32(row["Id"]),
                    Path = row["Path"].ToString(),
                    Name = row["Name"].ToString(),
                    IsRepresentative = bool.Parse(row["IsRepresentative"].ToString())

                });
            }
            return pictures;
        }
    }
}