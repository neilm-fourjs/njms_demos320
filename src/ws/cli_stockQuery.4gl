#+
#+ Generated from cli_stockQuery
#+
IMPORT com
IMPORT xml
IMPORT util
IMPORT os

#+
#+ Global Endpoint user-defined type definition
#+
TYPE tGlobalEndpointType RECORD # Rest Endpoint
  Address RECORD # Address
    Uri STRING # URI
  END RECORD,
  Binding RECORD # Binding
    Version STRING, # HTTP Version (1.0 or 1.1)
    ConnectionTimeout INTEGER, # Connection timeout
    ReadWriteTimeout INTEGER, # Read write timeout
    CompressRequest STRING # Compression (gzip or deflate)
  END RECORD
END RECORD

PUBLIC DEFINE Endpoint tGlobalEndpointType
    = (Address:(Uri: "https://generodemos.dynu.net/f/ws/r/ws_demo/stockQuery"))

# Error codes
PUBLIC CONSTANT C_SUCCESS = 0

################################################################################
# Operation /exit
#
# VERB: GET
# DESCRIPTION :Exit the service
#
PUBLIC FUNCTION exit() RETURNS(INTEGER, STRING)
  DEFINE fullpath base.StringBuffer
  DEFINE contentType STRING
  DEFINE req com.HTTPRequest
  DEFINE resp com.HTTPResponse
  DEFINE resp_body STRING

  TRY

    # Prepare request path
    LET fullpath = base.StringBuffer.Create()
    CALL fullpath.append("/exit")

    # Create request and configure it
    LET req =
        com.HTTPRequest.Create(
            SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
    IF Endpoint.Binding.Version IS NOT NULL THEN
      CALL req.setVersion(Endpoint.Binding.Version)
    END IF
    IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
      CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
    END IF
    IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
      CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
    END IF
    IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
      CALL req.setHeader("Content-Encoding", Endpoint.Binding.CompressRequest)
    END IF

    # Perform request
    CALL req.setMethod("GET")
    CALL req.setHeader("Accept", "text/plain")
    CALL req.DoRequest()

    # Retrieve response
    LET resp = req.getResponse()
    # Process response
    INITIALIZE resp_body TO NULL
    LET contentType = resp.getHeader("Content-Type")
    CASE resp.getStatusCode()

      WHEN 200 #Success
        IF contentType MATCHES "*text/plain*" THEN
          # Parse TEXT response
          LET resp_body = resp.getTextResponse()
          RETURN C_SUCCESS, resp_body
        END IF
        RETURN -1, resp_body

      OTHERWISE
        RETURN resp.getStatusCode(), resp_body
    END CASE
  CATCH
    RETURN -1, resp_body
  END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /getStockItem/{l_itemCode}
#
# VERB: GET
# DESCRIPTION :Get a Stock Item
#
PUBLIC FUNCTION getStockItem(p_l_itemCode STRING) RETURNS(INTEGER, STRING)
  DEFINE fullpath base.StringBuffer
  DEFINE contentType STRING
  DEFINE req com.HTTPRequest
  DEFINE resp com.HTTPResponse
  DEFINE resp_body STRING

  TRY

    # Prepare request path
    LET fullpath = base.StringBuffer.Create()
    CALL fullpath.append("/getStockItem/{l_itemCode}")
    CALL fullpath.replace("{l_itemCode}", p_l_itemCode, 1)

    # Create request and configure it
    LET req =
        com.HTTPRequest.Create(
            SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
    IF Endpoint.Binding.Version IS NOT NULL THEN
      CALL req.setVersion(Endpoint.Binding.Version)
    END IF
    IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
      CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
    END IF
    IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
      CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
    END IF
    IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
      CALL req.setHeader("Content-Encoding", Endpoint.Binding.CompressRequest)
    END IF

    # Perform request
    CALL req.setMethod("GET")
    CALL req.setHeader("Accept", "text/plain")
    CALL req.DoRequest()

    # Retrieve response
    LET resp = req.getResponse()
    # Process response
    INITIALIZE resp_body TO NULL
    LET contentType = resp.getHeader("Content-Type")
    CASE resp.getStatusCode()

      WHEN 200 #Success
        IF contentType MATCHES "*text/plain*" THEN
          # Parse TEXT response
          LET resp_body = resp.getTextResponse()
          RETURN C_SUCCESS, resp_body
        END IF
        RETURN -1, resp_body

      OTHERWISE
        RETURN resp.getStatusCode(), resp_body
    END CASE
  CATCH
    RETURN -1, resp_body
  END TRY
END FUNCTION
################################################################################

################################################################################
# Operation /listStock/{l_pgno}
#
# VERB: GET
# DESCRIPTION :Get Stock List
#
PUBLIC FUNCTION listStock(p_l_pgno INTEGER) RETURNS(INTEGER, STRING)
  DEFINE fullpath base.StringBuffer
  DEFINE contentType STRING
  DEFINE req com.HTTPRequest
  DEFINE resp com.HTTPResponse
  DEFINE resp_body STRING

  TRY

    # Prepare request path
    LET fullpath = base.StringBuffer.Create()
    CALL fullpath.append("/listStock/{l_pgno}")
    CALL fullpath.replace("{l_pgno}", p_l_pgno, 1)

    # Create request and configure it
    LET req =
        com.HTTPRequest.Create(
            SFMT("%1%2", Endpoint.Address.Uri, fullpath.toString()))
    IF Endpoint.Binding.Version IS NOT NULL THEN
      CALL req.setVersion(Endpoint.Binding.Version)
    END IF
    IF Endpoint.Binding.ConnectionTimeout <> 0 THEN
      CALL req.setConnectionTimeout(Endpoint.Binding.ConnectionTimeout)
    END IF
    IF Endpoint.Binding.ReadWriteTimeout <> 0 THEN
      CALL req.setTimeout(Endpoint.Binding.ReadWriteTimeout)
    END IF
    IF Endpoint.Binding.CompressRequest IS NOT NULL THEN
      CALL req.setHeader("Content-Encoding", Endpoint.Binding.CompressRequest)
    END IF

    # Perform request
    CALL req.setMethod("GET")
    CALL req.setHeader("Accept", "text/plain")
    CALL req.DoRequest()

    # Retrieve response
    LET resp = req.getResponse()
    # Process response
    INITIALIZE resp_body TO NULL
    LET contentType = resp.getHeader("Content-Type")
    CASE resp.getStatusCode()

      WHEN 200 #Success
        IF contentType MATCHES "*text/plain*" THEN
          # Parse TEXT response
          LET resp_body = resp.getTextResponse()
          RETURN C_SUCCESS, resp_body
        END IF
        RETURN -1, resp_body

      OTHERWISE
        RETURN resp.getStatusCode(), resp_body
    END CASE
  CATCH
    RETURN -1, resp_body
  END TRY
END FUNCTION
################################################################################
