component extends="base" {

	/**
	 * Get a list of all features for your account.
	 * 
	 * GET - https://app.launchdarkly.com/api/features
	 * 
	 * @method listFeatureFlags
	*/
	public any function listFeatureFlags(){
		var endpoint = this.expandEndpoint('/features', []);
		return this.execute(endpoint=endpoint, method="GET");
	}

	/**
	 * Get a single feature flag by key. This is the version of the flag that's live on your dashboard-- if you want to see the version that's being evaluated for feature flag requests, use the Get evaluable feature flag resource.
	 * 
	 * * GET - https://app.launchdarkly.com/api/features/:key
	 * 
	 * @method getFeatureFlag
	 * @param {String} key
	*/
	public any function getFeatureFlag(required string key){
		var endpoint = this.expandEndpoint('/features/:key', [key]);
		return this.execute(endpoint=endpoint, method="GET");
	}

	/**
	 * Get a single feature flag by key. This is the version of the flag that's live on your dashboard-- if you want to see the version that's being evaluated for feature flag requests, use the Get evaluable feature flag resource.
	 * 
	 * * GET - https://app.launchdarkly.com/api/features/:key
	 * 
	 * @method getFeatureFlag
	 * @param {String} key
	*/
	public any function getFeatureFlag(required string key){
		var endpoint = this.expandEndpoint('/features/:key', [key]);
		return this.execute(endpoint=endpoint, method="GET");
	}

	/**
	 * Get a single feature flag by key. This is the version of the flag that's live on your dashboard-- if you want to see the version that's being evaluated for feature flag requests, use the Get evaluable feature flag resource.
	 * 
	 * * GET - https://app.launchdarkly.com/api/features/:key
	 * 
	 * @method sendEvent
	 * @param {Any} event
	*/
	public void function track(required string key,
							  required LDUser user,
								  any data="",
								  string event_type = "custom"){

		var params = {"user":arguments.user.asStruct()};
		params["kind"] = arguments.event_type;
		params["key"] = arguments.key;
		params["creationDate"] = DateDiff("s", CreateDate(1970,1,1), Now()) * 100;
		params["data"] = arguments.data;

		var body = [];

		arrayAppend(body,params);

		var endpoint = this.expandEndpoint('/events/bulk', []);

		//thread action="run" name="#createUUID()#"{
			this.execute(endpoint=endpoint, method="POST", body=body);	
		//}


	}

	/**
	 * Get a single feature flag by key. This is the version of the flag that's live on your dashboard-- if you want to see the version that's being evaluated for feature flag requests, use the Get evaluable feature flag resource.
	 * 
	 * * GET - https://app.launchdarkly.com/api/features/:key
	 * 
	 * @method sendEvent
	 * @param {Any} event
	*/
	public void function identify(required LDUser user){

		var params = {"user":{}};
		params["kind"] = "identify";
		params.user = arguments.user.asStruct();
		params["key"] = arguments.user.getKey();
		params["creationDate"] = DateDiff("s", CreateDate(1970,1,1), Now()) * 100;

		var body = [];

		arrayAppend(body,params);

		var endpoint = this.expandEndpoint('/events/bulk', []);
		return this.execute(endpoint=endpoint, method="POST", body=body);
	}

	/**
	 * Get the value of a feature flag for the specified user.
	 * 
	 * POST - https://app.launchdarkly.com/api/eval/features/:key/:user
	 * 
	 * @method toggle
	 * @param {String} key
	 * @param {LDUser} user
	 * @param {Boolean} default
	*/
	public boolean function toggle(required string key, required LDUser user, boolean default=false, boolean bypass_cache=false){
		var endpoint = this.expandEndpoint('/eval/features/:key/:user', [key, user.asBase64()]);
		var result = ""
		var cache_id = hash(user.asBase64()) & "__" & arguments.key;

		if(!cacheidexists(cache_id, variables.cache_name) || bypass_cache){
			try{
				result = this.execute(endpoint=endpoint, method="GET");
				//writeDump(result);
				if(result.successful){
					if(isBoolean(result.response_parsed.value)){

						// put the value in cache..
						cacheput(id=cache_id , value=result.response_parsed.value, timespan=createTimeSpan(0,0,5,0), cacheName=variables.cache_name);
						return result.response_parsed.value
					}else{
						return arguments.default;
					}
				}else{
					return arguments.default;
				}

			}catch(any e){
				return arguments.default;
			}
		}else{
			//writeDump("from_cache");
			var cache_obj = cacheget(cache_id, variables.cache_name);
			//writeDump(cache_obj); abort;
			return cache_obj;
		}
	}

	function user(){
		return new LDUser();
	}




}