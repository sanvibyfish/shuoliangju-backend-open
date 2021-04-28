module ApiHelpers
    def json_response
        JSON.parse(response.body)
    end

    def json(hash)
        JSON.parse(JSON[hash])
    end
end