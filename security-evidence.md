# Security tests, by category

## Authorization:
- Updating the package service fails with insufficient authorization: [AuthorizationTest.scala](ledger-service/http-json/src/it/scala/http/AuthorizationTest.scala#L81)
- Updating the package service succeeds with sufficient authorization: [AuthorizationTest.scala](ledger-service/http-json/src/it/scala/http/AuthorizationTest.scala#L89)
- badly-authorized create is rejected: [AbstractHttpServiceIntegrationTest.scala](ledger-service/http-json/src/itlib/scala/http/AbstractHttpServiceIntegrationTest.scala#L1786)
- create IOU should fail if overwritten actAs & readAs result in missing permission even if the user would have the rights: [HttpServiceIntegrationTestUserManagement.scala](ledger-service/http-json/src/it/scala/http/HttpServiceIntegrationTestUserManagement.scala#L134)
- create IOU should fail if user has no permission: [HttpServiceIntegrationTestUserManagement.scala](ledger-service/http-json/src/it/scala/http/HttpServiceIntegrationTestUserManagement.scala#L108)
- create IOU should work with correct user rights: [HttpServiceIntegrationTestUserManagement.scala](ledger-service/http-json/src/it/scala/http/HttpServiceIntegrationTestUserManagement.scala#L81)
- fetch fails when readAs not authed, even if prior fetch succeeded: [AbstractHttpServiceIntegrationTest.scala](ledger-service/http-json/src/itlib/scala/http/AbstractHttpServiceIntegrationTest.scala#L1844)
- multiple websocket requests over the same WebSocket connection are NOT allowed: [AbstractWebsocketServiceIntegrationTest.scala](ledger-service/http-json/src/itlib/scala/http/AbstractWebsocketServiceIntegrationTest.scala#L118)
- reject requests with missing auth header: [AbstractHttpServiceIntegrationTest.scala](ledger-service/http-json/src/itlib/scala/http/AbstractHttpServiceIntegrationTest.scala#L1280)
- websocket request with invalid protocol token should be denied: [AbstractWebsocketServiceIntegrationTest.scala](ledger-service/http-json/src/itlib/scala/http/AbstractWebsocketServiceIntegrationTest.scala#L98)
- websocket request with valid protocol token should allow client subscribe to stream: [AbstractWebsocketServiceIntegrationTest.scala](ledger-service/http-json/src/itlib/scala/http/AbstractWebsocketServiceIntegrationTest.scala#L86)
- websocket request without protocol token should be denied: [AbstractWebsocketServiceIntegrationTest.scala](ledger-service/http-json/src/itlib/scala/http/AbstractWebsocketServiceIntegrationTest.scala#L108)

## Semantics:
- /v1/query GET succeeds after reconnect: [FailureTests.scala](ledger-service/http-json/src/failurelib/scala/http/FailureTests.scala#L153)
- /v1/query POST succeeds after reconnect: [FailureTests.scala](ledger-service/http-json/src/failurelib/scala/http/FailureTests.scala#L195)
- /v1/query POST succeeds after reconnect to DB: [FailureTests.scala](ledger-service/http-json/src/failurelib/scala/http/FailureTests.scala#L260)
- /v1/stream/query can reconnect: [FailureTests.scala](ledger-service/http-json/src/failurelib/scala/http/FailureTests.scala#L333)
- Command submission succeeds after reconnect: [FailureTests.scala](ledger-service/http-json/src/failurelib/scala/http/FailureTests.scala#L50)
- command submission timeout is applied: [FailureTests.scala](ledger-service/http-json/src/failurelib/scala/http/FailureTests.scala#L99)
- fromStartupMode should not succeed for any input when the db connection is broken: [FailureTests.scala](ledger-service/http-json/src/failurelib/scala/http/FailureTests.scala#L421)

## Performance:
- archiving a large number of contracts should succeed: [AbstractHttpServiceIntegrationTest.scala](ledger-service/http-json/src/itlib/scala/http/AbstractHttpServiceIntegrationTest.scala#L2136)
- creating and listing 20K users should be possible: [HttpServiceIntegrationTestUserManagement.scala](ledger-service/http-json/src/it/scala/http/HttpServiceIntegrationTestUserManagement.scala#L562)

## Input Validation:
- TLS configuration is parsed correctly from the config file: [CliSpec.scala](ledger-service/http-json/src/test/scala/com/digitalasset/http/CliSpec.scala#L273)

## Authentication:
- connect normally with tls on: [TlsTest.scala](ledger-service/http-json/src/it/scala/http/TlsTest.scala#L30)


