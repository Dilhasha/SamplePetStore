import ballerina/test;
import ballerina/http;

# Add a pet that does not already exist
# + return - Return an error or nil if there is no error  
@test:Config {}
function addNewPet() returns error? {
    http:Response response = check petStoreClient->post("/pet", "{\"id\":\"CAT6790\",\"name\":\"Sheeba\", \"isAvailable\":true}");
    test:assertEquals(response.statusCode, 200, "The expected status code was not returned.");
    test:assertEquals(response.getJsonPayload(), {"id": "CAT6790", "name": "Sheeba", "isAvailable": true}, "The expected success message was not returned.");
}

# Add a pet that already exists
# + return - Return an error or nil if there is no error   
@test:Config {}
function addPetWithExistingId() returns error? {
    http:Response response = check petStoreClient->post("/pet", "{\"id\":\"PARROT0009\",\"name\":\"Dakota\", \"isAvailable\":false}");
    test:assertEquals(response.statusCode, 405, "The expected status code was not returned.");
    test:assertEquals(response.getTextPayload(), "A pet with given pet id PARROT0009 already exists in the inventory.", "The expected error message was not returned.");
}

