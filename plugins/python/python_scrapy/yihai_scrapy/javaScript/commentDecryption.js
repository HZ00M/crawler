// utf-8
function stringToBytesUtf8(e) {
    return stringToBytesBin(unescape(encodeURIComponent(e)))
}

// bin
function stringToBytesBin(e) {
    for (var t = [], r = 0; r < e.length; r++)
        t.push(255 & e.charCodeAt(r));
    return t
}

function rotl(e, t) {
    return e << t | e >>> 32 - t
}

function endian(e) {
    if (e.constructor == Number)
        return 16711935 & rotl(e, 8) | 4278255360 & rotl(e, 24);
    for (var t = 0; t < e.length; t++)
        e[t] = endian(e[t]);
    return e
}

function _hh(e, t, r, n, o, i, a) {
    var u = e + (t & r | ~t & n) + (o >>> 0) + a;
    return (u << i | u >>> 32 - i) + t
}


function _gg(e, t, r, n, o, i, a) {
    var u = e + (t & n | r & ~n) + (o >>> 0) + a;
    return (u << i | u >>> 32 - i) + t
}

function _vv(e, t, r, n, o, i, a) {
    var u = e + (t ^ r ^ n) + (o >>> 0) + a;
    return (u << i | u >>> 32 - i) + t
}

function _ii(e, t, r, n, o, i, a) {
    var u = e + (r ^ (t | ~n)) + (o >>> 0) + a;
    return (u << i | u >>> 32 - i) + t
}

function bytesToWords(e) {
    for (var t = [], r = 0, n = 0; r < e.length; r++,
        n += 8)
        t[n >>> 5] |= e[r] << 24 - n % 32;
    return t
}

function L(e) {
    return !!e.constructor && "function" == typeof e.constructor.isBuffer && e.constructor.isBuffer(e)
}

function r(e) {
    return null != e && (L(e) || function (e) {
        return "function" == typeof e.readFloatLE && "function" == typeof e.slice && L(e.slice(0, 0))
    }(e) || !!e._isBuffer)
};

function oo(i, a) {
    i.constructor == String ? i = a && "binary" === a.encoding ? stringToBytesBin(i) : stringToBytesUtf8(i) : r(i) ? i = Array.prototype.slice.call(i, 0) : Array.isArray(i) || i.constructor === Uint8Array || (i = i.toString());
    for (var u = bytesToWords(i), s = 8 * i.length, c = 1732584193, l = -271733879, f = -1732584194, p = 271733878, d = 0; d < u.length; d++)
        u[d] = 16711935 & (u[d] << 8 | u[d] >>> 24) | 4278255360 & (u[d] << 24 | u[d] >>> 8);
    u[s >>> 5] |= 128 << s % 32,
        u[14 + (s + 64 >>> 9 << 4)] = s;
    var h = _hh
        , y = _gg
        , v = _vv
        , b = _ii;
    for (d = 0; d < u.length; d += 16) {
        var m = c
            , w = l
            , g = f
            , x = p;
        c = h(c, l, f, p, u[d + 0], 7, -680876936),
            p = h(p, c, l, f, u[d + 1], 12, -389564586),
            f = h(f, p, c, l, u[d + 2], 17, 606105819),
            l = h(l, f, p, c, u[d + 3], 22, -1044525330),
            c = h(c, l, f, p, u[d + 4], 7, -176418897),
            p = h(p, c, l, f, u[d + 5], 12, 1200080426),
            f = h(f, p, c, l, u[d + 6], 17, -1473231341),
            l = h(l, f, p, c, u[d + 7], 22, -45705983),
            c = h(c, l, f, p, u[d + 8], 7, 1770035416),
            p = h(p, c, l, f, u[d + 9], 12, -1958414417),
            f = h(f, p, c, l, u[d + 10], 17, -42063),
            l = h(l, f, p, c, u[d + 11], 22, -1990404162),
            c = h(c, l, f, p, u[d + 12], 7, 1804603682),
            p = h(p, c, l, f, u[d + 13], 12, -40341101),
            f = h(f, p, c, l, u[d + 14], 17, -1502002290),
            c = y(c, l = h(l, f, p, c, u[d + 15], 22, 1236535329), f, p, u[d + 1], 5, -165796510),
            p = y(p, c, l, f, u[d + 6], 9, -1069501632),
            f = y(f, p, c, l, u[d + 11], 14, 643717713),
            l = y(l, f, p, c, u[d + 0], 20, -373897302),
            c = y(c, l, f, p, u[d + 5], 5, -701558691),
            p = y(p, c, l, f, u[d + 10], 9, 38016083),
            f = y(f, p, c, l, u[d + 15], 14, -660478335),
            l = y(l, f, p, c, u[d + 4], 20, -405537848),
            c = y(c, l, f, p, u[d + 9], 5, 568446438),
            p = y(p, c, l, f, u[d + 14], 9, -1019803690),
            f = y(f, p, c, l, u[d + 3], 14, -187363961),
            l = y(l, f, p, c, u[d + 8], 20, 1163531501),
            c = y(c, l, f, p, u[d + 13], 5, -1444681467),
            p = y(p, c, l, f, u[d + 2], 9, -51403784),
            f = y(f, p, c, l, u[d + 7], 14, 1735328473),
            c = v(c, l = y(l, f, p, c, u[d + 12], 20, -1926607734), f, p, u[d + 5], 4, -378558),
            p = v(p, c, l, f, u[d + 8], 11, -2022574463),
            f = v(f, p, c, l, u[d + 11], 16, 1839030562),
            l = v(l, f, p, c, u[d + 14], 23, -35309556),
            c = v(c, l, f, p, u[d + 1], 4, -1530992060),
            p = v(p, c, l, f, u[d + 4], 11, 1272893353),
            f = v(f, p, c, l, u[d + 7], 16, -155497632),
            l = v(l, f, p, c, u[d + 10], 23, -1094730640),
            c = v(c, l, f, p, u[d + 13], 4, 681279174),
            p = v(p, c, l, f, u[d + 0], 11, -358537222),
            f = v(f, p, c, l, u[d + 3], 16, -722521979),
            l = v(l, f, p, c, u[d + 6], 23, 76029189),
            c = v(c, l, f, p, u[d + 9], 4, -640364487),
            p = v(p, c, l, f, u[d + 12], 11, -421815835),
            f = v(f, p, c, l, u[d + 15], 16, 530742520),
            c = b(c, l = v(l, f, p, c, u[d + 2], 23, -995338651), f, p, u[d + 0], 6, -198630844),
            p = b(p, c, l, f, u[d + 7], 10, 1126891415),
            f = b(f, p, c, l, u[d + 14], 15, -1416354905),
            l = b(l, f, p, c, u[d + 5], 21, -57434055),
            c = b(c, l, f, p, u[d + 12], 6, 1700485571),
            p = b(p, c, l, f, u[d + 3], 10, -1894986606),
            f = b(f, p, c, l, u[d + 10], 15, -1051523),
            l = b(l, f, p, c, u[d + 1], 21, -2054922799),
            c = b(c, l, f, p, u[d + 8], 6, 1873313359),
            p = b(p, c, l, f, u[d + 15], 10, -30611744),
            f = b(f, p, c, l, u[d + 6], 15, -1560198380),
            l = b(l, f, p, c, u[d + 13], 21, 1309151649),
            c = b(c, l, f, p, u[d + 4], 6, -145523070),
            p = b(p, c, l, f, u[d + 11], 10, -1120210379),
            f = b(f, p, c, l, u[d + 2], 15, 718787259),
            l = b(l, f, p, c, u[d + 9], 21, -343485551),
            c = c + m >>> 0,
            l = l + w >>> 0,
            f = f + g >>> 0,
            p = p + x >>> 0
    }
    return endian([c, l, f, p])
}


function wordsToBytes(e) {
    for (var t = [], r = 0; r < 32 * e.length; r += 8)
        t.push(e[r >>> 5] >>> 24 - r % 32 & 255);
    return t
}

function bytesToHex(e) {
    for (var t = [], r = 0; r < e.length; r++)
        t.push((e[r] >>> 4).toString(16)),
            t.push((15 & e[r]).toString(16));
    return t.join("")
}

// 实际解密，只要传第一个参数就行，参数=
function md5$2(t, r) {
    if (null == t)
        throw new Error("Illegal argument " + t);
    var i = wordsToBytes(oo(t, r));
    return bytesToHex(i)
}

// rr = "ea1db124af3c7062474693fa704f4ff8"
// rr = "BdiI92bjmZ9QRcjJBWv2EEssyjekAGKt"
// data = "mode=3&oid=223894975&pagination_str=%7B%22offset%22%3A%22%7B%5C%22type%5C%22%3A1%2C%5C%22direction%5C%22%3A1%2C%5C%22session_id%5C%22%3A%5C%221763673255219622%5C%22%2C%5C%22data%5C%22%3A%7B%7D%7D%22%7D&plat=1&type=1&web_location=1315875&wts=1722596366"
//
// console.log(md5$2(data+rr))