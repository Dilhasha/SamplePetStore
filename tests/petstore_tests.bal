import ballerina/test;
import ballerina/http;

@test:Config {}
function getNonExistentResource() {
    http:Response|http:ClientError response = petStoreClient->get("/nonexitant");
    if (response is http:Response) {
        test:assertEquals(response.statusCode, 404, "The expected error code was not returned.");
    } else {
        test:assertFail("Unexpected client error is returned.");
    }
}

@test:Config {}
function callUnavailableAction() {
    http:Response|http:ClientError response = petStoreClient->put("/nonexitant", "");
    if (response is http:Response) {
        test:assertEquals(404, response.statusCode, "The expected error code was not returned.");
        test:assertEquals(response.reasonPhrase, "Not Found", "The expected error code was not returned.");
    } else {
        test:assertFail("Unexpected client error is returned.");
    }
}