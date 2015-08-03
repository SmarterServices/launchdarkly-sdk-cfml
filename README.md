# LaunchDarkly CFML SDK/Client Lib

This library does not include the complete LaunchDarkly range of functions, just a few we needed to use.  We will be looking to build out further as the need expands.

LaunchDarkly includes a Java version which can also be used on ColdFusion and Railo, however we wanted to include a library in our codebase without the jar dependencies.

## Usage

```
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
```