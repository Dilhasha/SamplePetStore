import ballerina/test;
import ballerina/http;

http:Client petStoreClient = check new ("http://localhost:9090");

@test:Config {}
function getExistingPet() {
    http:Response|http:ClientError response = petStoreClient->get("/pet?id=PARROT0009");
    if (response is http:Response) {
        if (response.statusCode == 200) {
            test:assertEquals(response.getJsonPayload(), {"id": "PARROT0009", "name": "Dakota", "isAvailable": false}, "The returned response does not match the expected");
        } else {
            test:assertFail("The response contains unexpected status code.");
        }
    } else {
        test:assertFail("Unexpected client error is thrown.");
    }
}

@test:Config {}
function getNonExistantPet() {
    http:Response|http:ClientError response = petStoreClient->get("/pet?id=FISH0028");
    if (response is http:Response) {
        if (response.statusCode == 200) {
            test:assertEquals(response.getTextPayload(), "No pet is listed with the given pet id FISH0028", "The returned response does not match the expected");
        } else {
            test:assertFail("The response contains unexpected status code.");
        }
    } else {
        test:assertFail("Unexpected client error is thrown.");
    }
}

@test:Config {}
function getPetWithoutId() {
    http:Response|http:ClientError response = petStoreClient->get("/pet");
    if (response is http:Response) {
        if (response.statusCode == 500) {
            test:assertEquals(response.getTextPayload(), "The pet id is not provided.");
        } else {
            test:assertFail("The response contains unexpected status code.");
        }
    } else {
        test:assertFail("Unexpected client error is thrown.");
    }
}
