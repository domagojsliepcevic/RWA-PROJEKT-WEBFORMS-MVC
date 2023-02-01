function openCenteredWindow(url) {
    var windowWidth = 500;
    var windowHeight = 500;

    var windowLeft = (screen.width - windowWidth) / 2;
    var windowTop = (screen.height - windowHeight) / 2;

    var windowFeatures = "width=" + windowWidth + ",height=" + windowHeight + ",left=" + windowLeft + ",top=" + windowTop;

    var windowObject = window.open(url, "Image", windowFeatures);
    windowObject.document.body.classList.add("center-window");
}