$(document).ready(function () {
    $('#openModal').click(function () {
        $('#myModal').show();
    });
});
$(document).ready(function () {
    $('#closeModal').click(function () {
        $('#myModal').hide();
    });
});

$(document).ready(function () {
    $('#btnSubmit').click(function () {

        window.location.href = 'Account/Logout';

    });
});