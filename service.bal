import ballerina/http;

type Pet record {
    string id;
    string name;
    boolean isAvailable;
};

configurable int port = 9090;
configurable string hostEp = "localhost";

listener http:Listener petstoreListener = new (port, config = {host: hostEp});

service / on petstoreListener {

    private map<Pet> petInventory = {"PARROT0009": {id: "PARROT0009", name: "Dakota", isAvailable: false}};

    # Retrieve the pet details in json format for a given pet id.
    #
    # + return - pet details as json if the pet with given id exists
    #            or http:NotFound if the pet with given id does not exist
    #            or http:BadRequest if the request format is incorrect
    resource function get pet/[string petId]() returns @http:Payload {mediaType: "application/json+id"} Pet|http:BadRequest|http:NotFound {
        Pet? pet = self.petInventory[petId];
        if (pet is Pet) {
            return pet;
        } else {
            http:NotFound response = {body: "No pet is listed with the given pet id " + petId};
            return response;
        }
    }

    # Add the pet details passed in json format to the pet store.
    #
    # + payload - Pet details in json format
    # + return - Added pet details as json if the operation was successful
    #            or error message as json if pet with given id already exists
    #            or http:BadRequest if the request format is incorrect
    resource function post pet(@http:Payload {mediaType: ["application/json"]} Pet payload) returns @http:Payload {mediaType: "application/json+id"} Pet|http:MethodNotAllowed|http:BadRequest {
        if (self.petInventory[payload.id] is ()) {
            self.petInventory[payload.id] = payload;
            return payload;
        } else {
            http:MethodNotAllowed response = {body: "A pet with given pet id " + payload.id + " already exists in the inventory."};
            return response;
        }
    }

}
