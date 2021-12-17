/// A dispatcher for the UI REST Services
Class QCONNECT.Services.REST.UIDispatcher Extends (%CSP.REST, QCMasterLib.Services.REST.UIRESTBase, QCMasterLib.Utils.REST.Swagger.RouteAdapter) [ CompileAfter = (QCMasterLib.Services.REST.UIBaseTables, QCONNECT.Services.REST.UITables) ]
{

Parameter UseSession = 0;

/// Enable CORS
Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Map Prefix="/base" Forward="QCMasterLib.Services.REST.UIBaseTables" />
<Map Prefix="/qconnect" Forward="qconnect.Services.REST.UITables" />
<Route Url="/swagger" Method="GET" Call="GetSwagger"/><!-- GetSwagger inherited via MasterLib.Utils.REST.Swagger.RouteAdapter-->
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
