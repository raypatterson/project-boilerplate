/*
(function () {
    var DeviceRedirect, t, _ob, _win, __slice;
    __slice = [].slice;
    _win = window;
    _ob = _win;
    _ob.DeviceRedirect = DeviceRedirect = (function () {

        function DeviceRedirect() {
            var envRegEx, ignoreList, platforms;
            platforms = arguments[0], envRegEx = arguments[1], ignoreList = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
            this.platforms = platforms;
            this.envRegEx = envRegEx;
            this.ignoreList = ignoreList;
        }

        DeviceRedirect.prototype.init = function () {
            var href, isdesktop, ismobile, istablet, _i, _len, _ref;
            this.currentLocation = window.location.href.toLowerCase();
            this.isHere = this.currentLocation.match(this.envRegEx) ? true : false;
            ismobile = /iphone|ipod|android|blackberry|opera mini|opera mobi|windows phone|palm|iemobile/i.test(navigator.userAgent.toLowerCase());
            istablet = /ipad|tablet/i.test(navigator.userAgent.toLowerCase());
            isdesktop = ismobile || istablet ? false : true;

            this.isThis = {
                "mobile": ismobile,
                "tablet": istablet,
                "desktop": isdesktop
            };
            this.shouldIgnore = false;
            if (this.ignoreList != null) {
                _ref = this.ignoreList;
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                    href = _ref[_i];
                    if (this.currentLocation.match(href)) {
                        this.shouldIgnore = true;
                    }
                }
            }
            return this;
        };

        DeviceRedirect.prototype.go = function () {
            var location, notAlreadyThere, platform, _ref;
            // if (this.currentLocation.match(/localhost/g) || this.currentLocation.match(/localtunnel/g) || this.currentLocation.match(/8888/g) || this.shouldIgnore) {
            if (this.currentLocation.match(/localhost/g) || this.shouldIgnore) {

            } else {
                _ref = this.platforms;
                for (platform in _ref) {
                    location = _ref[platform];
                    location = location.toLowerCase();
                    notAlreadyThere = this.currentLocation.match(location) ? false : true;
                    if (this.isThis["" + platform] && notAlreadyThere) {
                        window.location = window.location.protocol + "//" + location;
                    }
                }
            }
            return this;
        };

        return DeviceRedirect;

    })();
    return t = setTimeout(function () {

        var localRedirect, 
        devRedirect, 
        reviewRedirect, 
        stagingOriginRedirect, 
        stagingCDNRedirect, 
        productionOriginRedirect, 
        productionCDNRedirect, 
        failsafeRedirect;

        clearTimeout(t);

        localRedirect = new _ob.DeviceRedirect({
            mobile: "localhost:8888",
            tablet: "localhost:4444",
            desktop: "localhost:4444"
        }, /localhost/g).init();

        devRedirect = new _ob.DeviceRedirect({
            mobile: "REDIRECT-URL-MOBILE",
            tablet: "REDIRECT-URL-TABLET",
            desktop: "REDIRECT-URL-DESKTOP"
        }, /SEARCH-PATTERN/g).init();

        reviewRedirect = new _ob.DeviceRedirect({
            mobile: "REDIRECT-URL-MOBILE",
            tablet: "REDIRECT-URL-TABLET",
            desktop: "REDIRECT-URL-DESKTOP"
        }, /SEARCH-PATTERN/g).init();

        stagingOriginRedirect = new _ob.DeviceRedirect({
            mobile: "REDIRECT-URL-MOBILE",
            tablet: "REDIRECT-URL-TABLET",
            desktop: "REDIRECT-URL-DESKTOP"
        }, /SEARCH-PATTERN/g).init();

        stagingCDNRedirect = new _ob.DeviceRedirect({
            mobile: "REDIRECT-URL-MOBILE",
            tablet: "REDIRECT-URL-TABLET",
            desktop: "REDIRECT-URL-DESKTOP"
        }, /SEARCH-PATTERN/g, "REDIRECT-URL-IGNORE").init();

        productionOriginRedirect = new _ob.DeviceRedirect({
            mobile: "REDIRECT-URL-MOBILE",
            tablet: "REDIRECT-URL-TABLET",
            desktop: "REDIRECT-URL-DESKTOP"
        }, /SEARCH-PATTERN/g).init();

        productionCDNRedirect = new _ob.DeviceRedirect({
            mobile: "REDIRECT-URL-MOBILE",
            tablet: "REDIRECT-URL-TABLET",
            desktop: "REDIRECT-URL-DESKTOP"
        }, /SEARCH-PATTERN/g, "REDIRECT-URL-IGNORE").init();

        failsafeRedirect = new _ob.DeviceRedirect({
            mobile: "REDIRECT-URL-MOBILE",
            tablet: "REDIRECT-URL-TABLET",
            desktop: "REDIRECT-URL-DESKTOP"
        }, null).init();

        if (localRedirect.isHere) {
            return localRedirect.go();
        } else if (devRedirect.isHere) {
            return devRedirect.go();
        } else if (reviewRedirect.isHere) {
            return reviewRedirect.go();
        } else if (stagingOriginRedirect.isHere) {
            return stagingOriginRedirect.go();
        } else if (stagingCDNRedirect.isHere) {
            return stagingCDNRedirect.go();
        } else if (productionOriginRedirect.isHere) {
            return productionOriginRedirect.go();
        } else if (productionCDNRedirect.isHere) {
            return productionCDNRedirect.go();
        } else {
            return failsafeRedirect.go();
        }
    }, 500);
})();
*/