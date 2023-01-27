﻿using rwaLib.DAL;
using rwaLib.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Javno.Controllers
{
    public class ApartmentController : Controller
    {
        public ApartmentRepository _apartmentRepository = new ApartmentRepository();
        public CityRepository _cityRepository = new CityRepository();
        public OrderRepository _orderRepository = new OrderRepository();

        public ActionResult Search(SearchModel model)
        {
            if (model == null)
            {
                model = new SearchModel();
            }
            else
            {
                model.SearchResult =
                _apartmentRepository.Search(
                model.FilterRooms,
                model.FilterAdults,
                model.FilterChildren,
                model.FilterCity,
                model.Order);
            }
            model.CityList = _cityRepository.GetCities();
            model.OrderList = _orderRepository.GetOrders();
            return View(model);
        }

        public ActionResult Picture(string path)
        {
            if (path == null || string.IsNullOrEmpty(path))
                return Content(content: "File missing"); // Rješenje "nabrzaka", nije najbolje
                                                         // Popravi putanju do slike, u bazi nije cijela putanja!
            var javnoRoot = Server.MapPath("~");
            var adminRoot = Path.Combine(javnoRoot, "../Admin/Content/Pictures");
            var picturePath = Path.Combine(adminRoot, path);
            string mimeType = MimeMapping.GetMimeMapping(picturePath);
            return new FilePathResult(picturePath, mimeType);
        }


    }
}