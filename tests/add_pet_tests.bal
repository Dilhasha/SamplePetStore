import ballerina/test;
import ballerina/http;

@test:Config {}
function addNewPet() {
    http:Response|http:ClientError response = petStoreClient->post("/pet", "{\"id\":\"CAT6790\",\"name\":\"Sheeba\", \"isAvailable\":true}");
    if (response is http:Response) {
        test:assertEquals(response.statusCode, 200, "The expected status code was not returned.");
        test:assertEquals(response.getJsonPayload(), {"id":"CAT6790","name":"Sheeba","isAvailable":true}, "The expected success message was not returned.");
    } else {
        test:assertFail("Unexpected client error is thrown.");
    }
}

@test:Config {}
function addPetWithExistingId() {
    http:Response|http:ClientError response = petStoreClient->post("/pet", "{\"id\":\"CAT3400\",\"name\":\"July\", \"isAvailable\":true}");
    if (response is http:Response) {
        test:assertEquals(response.statusCode, 200, "The expected status code was not returned.");
        test:assertEquals(response.getJsonPayload(), {"message": "A pet with given pet id CAT3400 already exists in the inventory."}, "The expected error message was not returned.");
    } else {
        test:assertFail("Unexpected client error is thrown.");
    }
}

@test:Config {}
function addPetWithIncorrectKey() {
    http:Response|http:ClientError response = petStoreClient->post("/pet", "{\"id\":\"CAT6790\",\"petname\":\"Sheeba\", \"isAvailable\":\"true\"}");
    validateBadRequest(response);
}

@test:Config {}
function addPetWithNonJsonPayload() {
    http:Response|http:ClientError response = petStoreClient->post("/pet", "This is a pet");
    validateBadRequest(response);
}

@test:Config {}
function addJsonWithWrongValue() {
    http:Response|http:ClientError response = petStoreClient->post("/pet", "{\"id\":\"CAT6790\",\"name\":\"Sheeba\", \"isAvailable\":\"hello\"}");
    validateBadRequest(response);
}

function validateBadRequest(http:Response|http:ClientError response) {
    if (response is http:Response) {
        test:assertEquals(response.statusCode, 400, "The expected error code was not returned.");
                string|http:ClientError errorResponse = response.getTextPayload();
        if (errorResponse is string) {
            test:assertTrue(errorResponse.startsWith("data binding failed"));
        } else {
            test:assertFail("Unexpected client error is returned when getting payload.");

        }
    } else {
        test:assertFail("Unexpected client error is thrown.");
    }
}