component accessors="true" displayname="LaunchDarkly Client Library" {

	property name="api_endpoint";
	property name="api_token";
	property name="cache_name";
	property name="runscope_bucket";
	property name="runscope_use_proxy";

	public any function init(required string api_token, 
							 		  string cache_name="",
							 		  string runscope_bucket="",
							 		  boolean runscope_use_proxy=false,
							 		  string api_endpoint="https://app.launchdarkly.com/api"){

		variables.api_token = Arguments.api_token;
		variables.api_endpoint = Arguments.api_endpoint;
		variables.cache_name = Arguments.cache_name;

		variables.runscope_bucket = Arguments.runscope_bucket;
		variables.runscope_use_proxy = Arguments.runscope_use_proxy;

		return this;
	}

	private string function expandEndpoint(required string endpoint, required array params){
		var placeholder = "";
		var finalEndpoint = "";
		var replacementCount = 1;

		for(var i = 1; i <= ListLen(endpoint, '/'); i++){
			placeholder = listGetAt(endpoint, i, '/');

			if(left(placeholder, 1) == ':'){
				placeholder = right(placeholder, len(placeholder)-1);

				if(ArrayLen(params) <= i){
					finalEndpoint = finalEndpoint &  "/" & params[replacementCount];
				replacementCount++;
				}else{
					finalEndpoint = finalEndpoint &  "/" & placeholder;
				}
			}else{
				finalEndpoint = finalEndpoint &  "/" & placeholder; 
			}
		}
		return finalEndpoint;
	}

	/**
	* @Hint Sends a given request as an HTTPPOST to the webhooks.io API.
	**/

	private any function execute(required string endpoint, 
										  string method="GET", 
										  any body="", 
										  struct headers=StructNew(),
										  string content_type="application/json"){
		var results = {
			"successful" = true,
			"http_status_text" = "",
			"http_status_code" = "",
			"response_parsed" = "",
			"response" = ""
		};
		var i = "";

		var httpSvc = new http();

			httpSvc.setUrl(this.runscopeify(getApi_endpoint() & '/' & arguments.endpoint, variables.runscope_bucket, variables.runscope_use_proxy));
			httpSvc.setMethod(Arguments.Method);
			
			httpSvc.addParam(type="header", name="Authorization",value="api_key " & getApi_Token()); 
			httpSvc.addParam(type="header", name="Content-Type",value=Arguments.content_type); 
			httpSvc.addParam(type="header", name="User-Agent",value="CFML LaunchDarkly Client/1.0"); 
writeDump(serializeJSON(arguments.body));
			if((isArray(Arguments.Body) || isStruct(Arguments.Body)) && arguments.content_type == 'application/json'){
				httpSvc.addParam(type="body",value=serializeJSON(arguments.body));
			}

			// add the request specific headers.
			for(i in arguments.headers){
				httpSvc.addParam(type="header", name=i,value=arguments.headers[i]); 
			}

		var sendResult = httpSvc.send().getPrefix();

		results["http_status_code"] = sendResult.responseheader.status_code;
		results["http_status_text"] = sendResult.responseheader.explanation;
		
		results["response"] = sendResult.filecontent;

		results["headers"] = sendResult.responseheader;

		if(sendResult.responseheader.status_code >= 300){
			results.successful = false;
			
		}

		if(results.successful){
			results["response_parsed"] = deserializeJSON(results.response);
		}

		return results;

	}

	function runscopeify( required string endpoint, required string bucket_id, boolean use_proxy = true ) {

	    if(!arguments.use_proxy) {
	            return ARGUMENTS.endpoint;
	    }

	    var oUrl = createObject("java", "java.net.URL").init(arguments.endpoint);

		var rs_host = replace(oUrl.getHost(), ".", "-", "all") & "-" & arguments.bucket_id & ".runscope.net";

		var return_url = oUrl.getProtocol() & "://" 
			// add any basic auth info
			if(len(trim(oUrl.getUserInfo()))){
				return_url = return_url & oUrl.getUserInfo() & "@";
			}
			// go ahead and add the host info..
			return_url = return_url & rs_host;
			// add the port if it is a non-standard port...
			if(len(trim(oUrl.getPort())) && oUrl.getPort() NEQ 80 && oUrl.getPort() NEQ 443){
				return_url = return_url & ":" & oUrl.getPort();
			}
			// add the path to call...
			if(len(trim(oUrl.getPath()))){
				return_url = return_url & oUrl.getPath();
			}
			// append any query params lastly...
			if(len(trim(oUrl.getQuery()))){
				return_url = return_url & "?" & oUrl.getQuery();
			}
		return return_url;
	}

}