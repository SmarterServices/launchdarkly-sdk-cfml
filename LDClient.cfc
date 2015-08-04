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
	 * Creates a new feature flag.
	 * 
	 * * POST - https://app.launchdarkly.com/api/features
	 * 
	 * @method createFeatureFlag
	 * @param {Struct} feature
	*/
	public any function createFeatureFlag(required struct feature){
		var endpoint = this.expandEndpoint('/features');
		return this.execute(endpoint=endpoint, method="POST", body=feature);
	}

	/**
	 * Updates a feature flag.
	 * 
	 * * PATCH - https://app.launchdarkly.com/api/features/:key
	 * 
	 * @method updateFeatureFlag
	 * @param {String} key
	 * @param {Struct} feature
	*/
	public any function updateFeatureFlag(required string key, required struct feature){
		var endpoint = this.expandEndpoint('/features/:key', [key]);
		return this.execute(endpoint=endpoint, method="PATCH", body=feature);
	}

	/**
	 * Delete a feature flag.
	 * 
	 * * DELETE - https://app.launchdarkly.com/api/features/:key
	 * 
	 * @method updateFeatureFlag
	 * @param {String} key
	*/
	public any function updateFeatureFlag(required string key){
		var endpoint = this.expandEndpoint('/features/:key', [key]);
		return this.execute(endpoint=endpoint, method="DELETE");
	}

	/**
	 * Get a single feature flag by key. This is the version of the flag that's live on your dashboard-- if you want to see the version that's being evaluated for feature flag requests, use the Get evaluable feature flag resource.
	 * 
	 * * POST - https://app.launchdarkly.com/api/features/:key
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

		
		this.execute(endpoint=endpoint, method="POST", body=body, async=true);

	}

	/**
	 * Get a single feature flag by key. This is the version of the flag that's live on your dashboard-- if you want to see the version that's being evaluated for feature flag requests, use the Get evaluable feature flag resource.
	 * 
	 * * POST - https://app.launchdarkly.com/api/features/:key
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
		
		this.execute(endpoint=endpoint, method="POST", body=body, async=true);
	}

	/**
	 * Get the value of a feature flag for the specified user.
	 * 
	 * GET - https://app.launchdarkly.com/api/eval/features/:key/:user
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
			var cache_obj = cacheget(cache_id, variables.cache_name);
			return cache_obj;
		}
	}

	function user(){
		return new LDUser();
	}




}