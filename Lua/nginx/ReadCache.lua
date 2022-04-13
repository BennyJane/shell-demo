ngx.header.content_type="application/json;charset=utf8"
-- 解析请求参数
local uri_args = ngx.req.get_uri_args();
local id = uri_args["id"];
--获取本地Nginx缓存：需要在Nginx中定义dis_cache缓存块
local cache_ngx = ngx.shared.dis_cache;
--根据ID 获取本地缓存数据
local contentCache = cache_ngx:get('content_cache_'..id);

if contentCache == "" or contentCache == nil then
    -- 导入redis模块
    local redis = require("resty.redis");
    local red = redis:new()
    red:set_timeout(2000)
    red:connect("192.168.211.132", 6379)
    -- 获取redis中数据
    local rescontent=red:get("content_"..id);

    if ngx.null == rescontent then
        -- 当redis中没有数据时，请求Mysql获取数据
        local cjson = require("cjson");
        local mysql = require("resty.mysql");
        local db = mysql:new();
        db:set_timeout(2000)
        local props = {
            host = "192.168.211.132",
            port = 3306,
            database = "changgou_content",
            user = "root",
            password = "123456"
        }
        local res = db:connect(props);
        local select_sql = "select url,pic from tb_content where status ='1' and category_id="..id.." order by sort_order";
        res = db:query(select_sql);
        local responsejson = cjson.encode(res);
        -- 更新redis
        red:set("content_"..id,responsejson);
        ngx.say(responsejson);
        -- 关闭数据库
        db:close()
    else
        -- 设置nginx缓存
        cache_ngx:set('content_cache_'..id, rescontent, 10*60);
        ngx.say(rescontent)
    end
    red:close()
else
    -- 直接返回
    ngx.say(contentCache)
end