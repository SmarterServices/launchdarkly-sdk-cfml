component output="false" accessors="true"{

	property name="key" type="string";
	property name="ip" type="string";
	property name="country" type="string";
	property name="email" type="string";
	property name="firstName" type="string";
	property name="lastName" type="string";
	property name="avatar" type="string";
	property name="custom" type="struct";

	public function init(){
		variables.custom = {};
		return this;
	}

	public function addCustom(string key, string value){
		variables.custom["#arguments.key#"] = arguments.value;
	}

	public function asStruct(){
		var string = "";
		var struct = {};
		struct["key"] = getKey();
		if(len(trim(getIp())))
			struct["ip"] = getIp();
		if(len(trim(getCountry())))
			struct["country"] = getCountry();
		if(len(trim(getEmail())))
			struct["email"] = getEmail();
		if(len(trim(getFirstName())))
			struct["firstName"] = getFirstName();
		if(len(trim(getLastname())))
			struct["lastName"] = getLastname();
		if(len(trim(getAvatar())))
			struct["avatar"] = getAvatar();

		if(listLen(structKeyList(getCustom())) > 0)
			struct["custom"] = getCustom();

		return struct;
	}

	public function asJson(){
		return serializeJSON(this.asStruct());
	}

	public function asBase64(){
		return this.base64urlEncode(this.asJson());
	}

	/**
    * I encode the given UTF-8 string using base64url encoding.
    *
    * @value I am the UTF-8 string to encode.
    * @output false
    */
    private string function base64urlEncode( required string value ) {
        // Get the binary representation of the UTF-8 string.
        var bytes = charsetDecode( value, "utf-8" );
        // Encode the binary using the core base64 character set.
        var encodedValue = binaryEncode( bytes, "base64" );
        // Replace the characters that are not allowed in the base64url format. The
        // characters [+, /, =] are removed for URL-based base64 values because they
        // have significant meaning in the context of URL paths and query-strings.
        encodedValue = replace( encodedValue, "+", "-", "all" );
        encodedValue = replace( encodedValue, "/", "_", "all" );
        encodedValue = replace( encodedValue, "=", "", "all" );
        return( encodedValue );
    }


}