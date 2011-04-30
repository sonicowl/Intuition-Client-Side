UrlLoader = class("UrlLoader")

UrlLoader.callbackHandler = nil
UrlLoader.networkListener = nil

function UrlLoader:initialize(url, callback)
	UrlLoader.callbackHandler = callback
	network.request(url, "GET", UrlLoader.networkListener)
end

UrlLoader.networkListener = function(event)
	if event.isError then
		native.showAlert("Network Error", event.response, {"OK"})
	else
		UrlLoader.callbackHandler(event.response)	
	end
end