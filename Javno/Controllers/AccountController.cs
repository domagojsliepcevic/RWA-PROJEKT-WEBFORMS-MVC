using rwaLib.Models;
using rwaLib.Utils;
using rwaLib.DAL;
using System.Web.Mvc;


namespace Javno.Controllers
{
    public class AccountController : Controller
    {

        public UserRepository _userRepository = new UserRepository();


        public ActionResult LogIn()
        {
            var model = new User();
            return View(model);
        }


        [HttpPost]
        public ActionResult LogIn(User user)
        {

            var authuser = _userRepository.AuthUser(user.Email, Cryptography.HashPassword(user.PasswordHash));
            if (authuser != null)
            {
                Session["Email"] = authuser.Email;
                return RedirectToAction("Index", "Home");
            }
            else
            {
                ViewBag.Notification = "Invalid email or password";
            }

            return View();
        }

        public ActionResult Registration()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Registration(User user)
        {
            if (ModelState.IsValid)
            {
                _userRepository.CreateUser(user);
                Session["Email"] = user.Email;
                TempData["AlertMsg"] = "Uspjesna registracija";
                return RedirectToAction("Index", "Home");
            }
            return View();
        }


        public ActionResult Logout()
        {
            Session.Clear();
            return RedirectToAction(actionName: "Index", controllerName: "Home");
        }
    }
}