using rwa.Models;
using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;


namespace rwaLib.DAL
{
    public class UserRepository
    {

        private readonly string _connectionString;
        public UserRepository()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["rwadb"].ConnectionString;
        }


        public User AuthUser(string email, string password)
        {
            var tblUser = SqlHelper.ExecuteDataset(_connectionString, nameof(AuthUser), email, password).Tables[0];
            if (tblUser.Rows.Count == 0) return null;
            DataRow row = tblUser.Rows[0];
            return new User
            {
                Id = row[nameof(User.Id)].ToString(),
                FirstName = row[nameof(User.FirstName)].ToString(),
                LastName = row[nameof(User.LastName)].ToString(),
                Address = row[nameof(User.Address)].ToString(),
                Email = row[nameof(User.Email)].ToString()
            };
        }

        public List<User> GetUsers()
        {
            var users = new List<User>();

            var tblusers = SqlHelper.ExecuteDataset(_connectionString, nameof(GetUsers)).Tables[0];
            foreach (DataRow row in tblusers.Rows)
            {
                users.Add(new User
                {
                    Id = row[nameof(User.Id)].ToString(),
                    Guid = (Guid)row[nameof(User.Guid)],
                    CreatedAt = (DateTime)row[nameof(User.CreatedAt)],
                    Email = row[nameof(User.Email)].ToString(),
                    EmailConfirmed = (bool)row[nameof(User.EmailConfirmed)],
                    PasswordHash = row[nameof(User.PasswordHash)].ToString(),
                    SecurityStamp = row[nameof(User.SecurityStamp)].ToString(),
                    PhoneNumber = row[nameof(User.PhoneNumber)].ToString(),
                    UserName = row[nameof(User.UserName)].ToString(),
                    Address = row[nameof(User.Address)].ToString()

                });

            }
            return users;
            
        }

    }
}