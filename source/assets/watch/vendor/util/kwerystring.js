/*
Name: KweryString.js
Author: John Newman
Date: 1/12/2012
License: MIT
Description: Converts a url with a query string into an object of parsed variables.  Also turns an
object full of values into a query string and plugs it into a url.
*/

(function (context) {
    "use strict";

    var rx = {
        "allNumbers" : new RegExp(/[0-9\.]+/),
        "boolString" : new RegExp(/(true|false)/i),
        "arrItem"    : new RegExp(/[^\[]+\[\]/),
        "objItem"    : new RegExp(/[^\{]+\{[^\}]+\}/)
    };

    // The reverse of cdr
    function lead(a) {
        return (typeof a === 'string' ? String : Array).prototype.slice.call(a, 0, a.length - 1);
    }

    // Get any object's type
    function getType(obj) {
        return lead(Object.prototype.toString.call(obj).slice(8));
    }

    // An array looper that hits just items, no indeces
    function withEach(arr, func) {
        var i, l = arr.length;
        for (i = 0; i < l; i += 1) {
            func(arr[i]);
        }
    }

    // A JSON looper that hits keys and values
    function chart(obj, func) {
        var i;
        for (i in obj) {
            if (Object.prototype.hasOwnProperty.call(obj, i)) {
                func(i, obj[i]);
            }
        }
    }

    // Turn a boolean string into real boolean
    function parseBool(val) {
        var lower = val.toLowerCase();
        if (lower === 'true') {
            return true;
        } else if (lower === 'false') {
            return false;
        } else {
            return val;
        }
    }

    // Convert almost anything to a string
    function stringify(obj) {
        var type = getType(obj);
        if (type === 'String') {
            return obj;
        } else if (type === 'Object' || type === 'Array' || type === 'NodeList' || type === 'Arguments') {
            return JSON.stringify(obj);
        } else {
            return String(obj);
        }
    }

    // Turn URL variables into a data object
    // Supports cool stuff like 'foo[]=hello&foo[]=goodbye' -> {"foo" : ["hello", "goodbye"]}
    // Also... 'foo{x}=hello&foo{y}=goodbye' -> {"foo" : {"x" : "hello", "y" : "goodbye"}}
    // Config should be like:
    /*
        {
            "parseBool" : true // -> 'false' would be turned into false
            "parseNum"  : true // -> '4' would be turned into 4
        }
    */
    function objectify(url, config) {

        // Decode the URI and grab the slice after the question mark
        var qsa = context.decodeURI(url.slice(url.indexOf('?') + 1)),
            // Determine if there is a hash sign in our string.
            // If so, it could be an in-page link tacked on the end which we don't want.
            lioHash = qsa.lastIndexOf('#'),
            prevChar,
            nextChar,
            newObj = {},
            arrayBuilder = {};

        // If we have a hash sign in our string
        if (lioHash !== -1) {
            prevChar = qsa.charAt(lioHash - 1);
            nextChar = qsa.charAt(lioHash + 1);
            // If that hash sign is not contained in quotes it is definitely
            // an in-page link tacked on the end
            if ((prevChar !== '"' && nextChar !== '"') ||
                    (prevChar !== "'" && nextChar !== "'")) {
                // Slice off the in-page link
                qsa = qsa.slice(0, lioHash);
            }
        }

        // Split our query string into an array
        qsa = qsa.split('&');

        // Loop over each item in the query string array
        withEach(qsa, function (item) {
            var k = item.slice(0, item.indexOf('=')),
                v = item.slice(item.indexOf('=') + 1),
                vlen = v.length,
                varName,
                index,
                boolstr,
                numstr;

            // Do any value converting as specified by our config object
            if (config) {
                // Parse booleans
                if (config.parseBool === true) {
                    boolstr = rx.boolString.exec(v);
                    if (boolstr && boolstr[0].length === vlen) {
                        v = parseBool(v);
                    }
                }
                // Parse numbers
                if (config.parseNum === true) {
                    numstr = rx.allNumbers.exec(v);
                    if (numstr && numstr[0].length === vlen) {
                        v = parseFloat(v);
                    }
                }
            }

            // If the current item should be part of an array...
            if (rx.arrItem.test(k)) {
                // Build an array inside of the arrayBuilder object
                varName = k.slice(0, k.indexOf('['));
                if (!arrayBuilder[varName]) {
                    arrayBuilder[varName] = [];
                }
                arrayBuilder[varName].push(v);
            // If the current item should be part of an object...
            } else if (rx.objItem.test(k)) {
                varName = k.slice(0, k.indexOf('{'));
                index = k.slice(k.indexOf('{') + 1, k.length - 1);
                if (!newObj[varName]) {
                    newObj[varName] = {};
                }
                newObj[varName][index] = v;
            // If it's just a name/value assignment
            } else {
                newObj[k] = v;
            }
        });

        // Put all the arrays in arrayBuilder into the newObj object
        chart(arrayBuilder, function (k, v) {
            newObj[k] = v;
        });

        return newObj;
    }

    // Turn an object into a querystring you can pass to a url
    // Supports all the same formats as deparsify
    // Config should be like:
    /*
        {
            "buildURL" : www.example.com // puts the query string on the end of the url.  if the value is 'true', uses location.href
            "keepHashLink" : true // keeps in-page links that look like '#location' on the end.  only works if you used buildURL
        }
    */
    function deobjectify(values, config) {
        var accum = '', configaccum;
        chart(values, function (k, v) {
            var kind = getType(v);
            if (kind === 'Array') {
                withEach(v, function (a) {
                    accum += ('&' + k + '[]=' + stringify(a));
                });
            } else if (kind === 'Object') {
                chart(v, function (a, b) {
                    accum += ('&' + k + '{' + a + '}=' + stringify(b));
                });
            } else {
                accum += ('&' + k + '=' + stringify(v));
            }
        });
        if (config) {
            configaccum = '';
            if (config.buildURL === true || config.buildURL === context.location.href) {
                configaccum += context.location.href.slice(0, context.location.href.lastIndexOf('#'));
                configaccum += ('?' + accum.slice(1));
                if (config.keepHashLink === true) {
                    configaccum += context.location.href.slice(context.location.href.lastIndexOf('#'));
                }
            } else if (config.buildURL) {
                configaccum += (config.buildURL + '?' + accum.slice(1));
            }

            return context.encodeURI(configaccum);
        }
        return context.encodeURI('?' + accum.slice(1));
    }

    context.KS = context.KweryString = {
        "getVars" : function (url, config) {
            return objectify(url, config);
        },

        "makeVars" : function (url, config) {
            return deobjectify(url, config);
        }
    };

}(this));