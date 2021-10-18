Class CustomFS.MyOperations Extends HS.FHIRServer.Storage.BuiltInOperations
{

// ClassMethod FHIRPatientOpAnonymize(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)

// {

// }

ClassMethod FHIRInstanceOpZzzzz(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	set ^kami=pRequest.QueryString
}

ClassMethod FHIRInstanceOpAnonymize(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	Set clientObj = ##class(HS.FHIRServer.RestClient.FHIRService).CreateInstance(pRequest.SessionApplication)
	Do clientObj.SetResponseFormat("JSON")
	set clientResponseObj=clientObj.Read(pRequest.RequestMethod,pRequest.Type,pRequest.Id)
	
	set pResponse.Json=clientResponseObj.Json
	set pResponse.Status=clientResponseObj.Status
	set pResponse.ETag=clientResponseObj.ETag
	set pResponse.LastModified=clientResponseObj.LastModified
	set pResponse.Location=clientResponseObj.Location
	set pResponse.IsPrettyOut=clientResponseObj.IsPrettyOut

		
	//anonymize
	if pResponse.Status="200" {
		set iter=pResponse.Json.name.%GetIterator()
		while iter.%GetNext(.key,.value) {
			do pResponse.Json.name.%Get(key).%Set("text","***********")
			do pResponse.Json.name.%Get(key).%Set("family","***********")
			do pResponse.Json.name.%Get(key).%Set("given","***********")
		}			
	}
}

ClassMethod AddSupportedOperations(pMap As %DynamicObject)
{
	Do ##super(pMap)
    Do pMap.%Set("anonymize","http://myfhirserver/fhir/OperationDefinition/patient-anonymize")
    Do pMap.%Set("zzzzz","http://myfhirserver/fhir/OperationDefinition/patient-zzzzz")
}

}
