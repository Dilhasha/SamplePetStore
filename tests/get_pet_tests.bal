import ballerina/test;
import ballerina/http;

configurable string petStoreServiceURL = "http://localhost:9090";

 http:Client petStoreClient = check new (petStoreServiceURL);

@test:Config {}
function getExistingPet() {
    http:Response|http:ClientError response = petStoreClient->get("/pet/PARROT0009");
    if (response is http:Response) {
        if (response.statusCode == 200) {
            test:assertEquals(response.getJsonPayload(), {"id": "PARROT0009", "name": "Dakota", "isAvailable": false}, "The returned response does not match the expected");
        } else {
            test:assertFail("The response contains unexpected status code.");
        }
    } else {
        test:assertFail("Unexpected client error is returned.");
    }
}

@test:Config {}
function getNonExistentPet() {
    http:Response|http:ClientError response = petStoreClient->get("/pet/FISH0028");
    if (response is http:Response) {
        if (response.statusCode == 404) {
            test:assertEquals(response.getTextPayload(), "No pet is listed with the given pet id FISH0028", "The returned response does not match the expected");
        } else {
            test:assertFail("The response contains unexpected status code.");
        }
    } else {
        test:assertFail("Unexpected client error is returned.");
    }
}

@test:Config {}
function getPetWithoutId() {
    http:Response|http:ClientError response = petStoreClient->get("/pet/");
    if (response is http:Response) {
        if (response.statusCode == 405) {
            test:assertEquals(response.getTextPayload(), "Method not allowed");
        } else {
            test:assertFail("The response contains unexpected status code.");
        }
    } else {
        test:assertFail("Unexpected client error is returned.");
    }
}

@test:Config {}
function getPetWithInvalidParameters() {
    http:Response|http:ClientError response = petStoreClient->get("/pet?id=PARROT0009");
    if (response is http:Response) {
        if (response.statusCode == 405) {
            test:assertEquals(response.getTextPayload(), "Method not allowed");
        } else {
            test:assertFail("The response contains unexpected status code.");
        }
    } else {
        test:assertFail("Unexpected client error is returned.");
    }
}
