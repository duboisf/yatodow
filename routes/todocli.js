exports.home = function (req, res) {
    res.render('home', {
        title: 'TodoCLI'
    });
};

exports.test_json = function (req, res) {
    res.send({
        success: true,
        message: "nice"
    });
};
