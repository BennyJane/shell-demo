function obj2Json(obj) {
    var res = eval("(" + obj + ")");
    // eslint-disable-next-line no-redeclare
    var jsonStr = JSON.stringify(res)
    return jsonStr
}