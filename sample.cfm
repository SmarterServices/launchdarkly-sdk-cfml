<cfscript>
	/*
	This settings file just has a structure that holds settings.  You can use the 
	structure below to create this or just add it here.
	
	settings = {
		api_token: "",
		cache_name:""
		runscope_bucket : "",
		runscope_use_proxy : true
	};
	*/
	include "settings.cfm";	

	LDClient = new LDClient(api_token=settings.api_token, 
							cache_name=settings.cache_name,
							runscope_bucket = settings.runscope_bucket,
							runscope_use_proxy = settings.runscope_use_proxy);
	
	LDUser = LDClient.user();

	LDUser.setKey("12345678");
	LDUser.setFirstName("John");
	LDUser.setLastName("Doe");
	LDUser.setEmail("jdoe@email.com");
	LDUser.addCustom("account", "100");
	LDUser.addCustom("region", "us-east");

	// see if the user has feature a enabled..
	feature_a = LDClient.toggle("feature.a", LDUser, false, true);
	writeDump(feature_a);

	// see if the user has feature b enabled..
	feature_b = LDClient.toggle("feature.b", LDUser, false, true);
	writeDump(feature_b)
</cfscript>