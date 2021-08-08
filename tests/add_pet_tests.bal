import ballerina/test;
import ballerina/http;

@test:Config {}
function addNewPet() {
    http:Response|http:ClientError response = petStoreClient->post("/addPet", "{\"Pet\":{\"id\":\"CAT6790\",\"name\":\"Sheeba\", \"isAvailable\":true}}");
    if (response is http:Response) {
        test:assertEquals(response.statusCode, 200, "The expected status code was not returned.");
        test:assertEquals(response.getTextPayload(), "The pet 'CAT6790' was successfully added to the inventory.", "The expected success message was not returned.");
    } else {
        test:assertFail("Unexpected client error is thrown.");
    }
}

@test:Config {}
function addPetWithIncorrectKey() {
    http:Response|http:ClientError response = petStoreClient->post("/addPet", "{\"Pet\":{\"id\":\"CAT6790\",\"petname\":\"Sheeba\", \"isAvailable\":\"true\"}}");
    if (response is http:Response) {
        test:assertEquals(response.statusCode, 500, "The expected error code was not thrown.");
        test:assertEquals(response.getTextPayload(), "{ballerina/lang.map}KeyNotFound", "The expected error message was not returned.");
    } else {
        test:assertFail("Unexpected client error is thrown.");
    }
}

@test:Config {}
function addPetWithNonJsonPayload() {
    http:Response|http:ClientError response = petStoreClient->post("/addPet", "This is a pet");
    if (response is http:Response) {
        test:assertEquals(response.statusCode, 500, "The expected error code was not thrown.");
        test:assertEquals(response.getTextPayload(), "Error occurred while retrieving the json payload from the request", "The expected error message was not returned.");
    } else {
        test:assertFail("Unexpected client error is thrown.");
    }
}

@test:Config {}
function addJsonWithWrongValue() {
    http:Response|http:ClientError response = petStoreClient->post("/addPet", "{\"Pet\":{\"id\":\"CAT6790\",\"name\":\"Sheeba\", \"isAvailable\":\"hello\"}}");
    if (response is http:Response) {
        test:assertEquals(response.statusCode, 500, "The expected status code was not returned.");
        test:assertEquals(response.getTextPayload(), "The flag 'isAvailable' needs to be a boolean value.", "The expected error message was not returned.");
    } else {
        test:assertFail("Unexpected client error is thrown.");
    }
}

@test:Config {}
function addEmptyJsonPayload() {
    http:Response|http:ClientError response = petStoreClient->post("/addPet", "{}");
    if (response is http:Response) {
        test:assertEquals(response.statusCode, 500, "The expected status code was not returned.");
        test:assertEquals(response.getTextPayload(), "{ballerina/lang.map}KeyNotFound", "The expected error message was not returned.");
    } else {
        test:assertFail("Unexpected client error is thrown.");
    }
}
