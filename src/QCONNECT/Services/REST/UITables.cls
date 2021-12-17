Class QCONNECT.Services.REST.UITables Extends (%CSP.REST )
{

Parameter UseSession = 0;

/// Enable CORS
Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
	<Route Url="/omofberplookup" 				Method="GET"	Call="GetOMOFBERPLookupList"/>
</Routes>
}

XData MsgMap
{
<Routes>
	<Route 	Url="/omofberplookup" 				Method="GET" 	RspMsg="MasterLib.Messages.Rsp.GenericUIRsp" 	RspFieldObjects="Data:OMCMOS.Tables.OMOFBERPLookup:jsonarray"                         																													Headers="X-UI-FILTER;X-UI-SORT;X-UI-PAGE;X-UI-UID;X-UI-UIDSOURCE"/>
</Routes>
}

/// This is the CORS request handler. User should override this method in their subclass
/// if they don't want the default behavior
ClassMethod OnHandleCorsRequest(pUrl As %String) As %Status
{
    #dim sc As %Status = $$$OK
    #dim tEx As %Exception.AbstractException
    Try {    
        #; Get request origin and compare to loaded origins
        set tCO = $get(^corsconfig("origins"),"")
        set tOrigin=$Get(%request.CgiEnvs("HTTP_ORIGIN"))
        if ($listlength(tCO) = 0) {
	        do ..SetResponseHeaderIfEmpty("Access-Control-Allow-Origin","*")
        } else {
	        if ($listfind(tCO,tOrigin) = 0) {
	        	do ..SetResponseHeaderIfEmpty("Access-Control-Allow-Origin","")
	        } else {
		        do ..SetResponseHeaderIfEmpty("Access-Control-Allow-Origin",tOrigin)
    		}
        }
       
        #; Set allow credentials to be true
        do ..SetResponseHeaderIfEmpty("Access-Control-Allow-Credentials",$get(^corsconfig("allowcredentials"),"true"))
        
        #; Allow requested headers
        set tHeaders = $Get(%request.CgiEnvs("HTTP_ACCESS_CONTROL_REQUEST_HEADERS"))
        do ..SetResponseHeaderIfEmpty("Access-Control-Allow-Headers",tHeaders)
        
        #; Allow requested method
        set tMethod = $get(%request.CgiEnvs("HTTP_ACCESS_CONTROL_REQUEST_METHOD"))
        Do ..SetResponseHeaderIfEmpty("Access-Control-Allow-Methods",tMethod)
        
    } Catch (tEx) {
        Set sc = e.AsStatus()
    }
    Quit sc
}

}
