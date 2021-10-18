Class CustomFS.MyInteractions Extends HS.FHIRServer.Storage.Json.Interactions
{

Parameter OperationHandlerClass As %String = "CustomFS.MyOperations";

/// @API Notification that a request in about to be dispatched.  The Interactions object
/// may use this to manage any session information or other bookkeeping.  By default, no processing
/// is performed.
/// @Input pFHIRService  The instance of HS.FHIRServer.Service that invoked this method
/// @Input pFHIRRequest  The request about to be processed
/// @Input pTimeout      The maximum number of sessions between requests that session data remains valid
Method OnBeforeRequest(pFHIRService As HS.FHIRServer.API.Service, pFHIRRequest As HS.FHIRServer.API.Data.Request, pTimeout As %Integer)
{
	//POST or PUTでPatientが対象の場合

	if ((pFHIRRequest.RequestMethod="POST")||(pFHIRRequest.RequestMethod="PUT"))&&(pFHIRRequest.RequestPath["Patient") {

		if $IsObject(pFHIRRequest.Json) {
			//set ^test("OBR!pFHIRRequest.Json")=pFHIRRequest.Json.%ToJSON()

			s tele=pFHIRRequest.Json.telecom.%Get(0).value

			if $Extract(tele,1,3)="401" $$$ThrowFHIR($$$HttpOnlyResponse(401))
			if $Extract(tele,1,3)="403" $$$ThrowFHIR($$$HttpOnlyResponse(403))
			if $Extract(tele,1,3)="400" $$$ThrowFHIR($$$GeneralError, "あなたの電話番号は登録する権利がありません。", $$$OutcomeNotSupported(400))

		}

	}



	//$$$ThrowFHIR($$$HttpOnlyResponse(403))
}

Method PostProcessRead(pResourceObject As %DynamicObject) As %Boolean
{
  //Evaluate consent based on the resource and user/roles.
  //Returning 0 indicates this resource shouldn't be displayed - a 404 Not Found
  //will be returned to the user.


	//40で始まる電話番号を持つPatientは絶対に返してはいけない・・・
	if pResourceObject.resourceType="Patient" {
		if $Extract(pResourceObject.telecom.%Get(0).value,1,2)="40" {
			//return 0
			set pResourceObject.telecom.%Get(0).value="******"
		}
	}

	return 1
}

}
