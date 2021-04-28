module Api
    module V1
        module Code
            module HttpBase
                HTTP_FORBIDDEN = 403
                HTTP_INTERNAL_SERVER_ERROR = 500
                HTTP_UNAUTHORIZED = 401
                HTTP_BAD_REQUEST = 400
                HTTP_UNPROCESSABLE_ENTITY = 422
                HTTP_NOT_FOUND = 404
                HTTP_BAD_GATEWAY = 502
                HTTP_OK = 200
                HTTP_CREATED = 201
                HTTP_NO_CONTENT = 204
                HTTP_METHOD_NOT_FOUND = 405
            end
            module HttpExtend
                USER_PRESENCED = 10000
                TOKEN_EXPIRED = 10001
                USER_AUTH_FAIL = 10002
                WECAT_SESSION_KEY_NOT_FOUND = 10003
                BODY_INVALID = 10004
                TOKEN_INVALID = 10005
            end
        end   
    end
end
