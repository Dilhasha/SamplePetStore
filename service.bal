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

    private map<Pet> petInventory = {"DOG0020": {id: "DOG0020", name: "Snowy", isAvailable: true}, "CAT3400": {id: "CAT3400", name: "Kygo", isAvailable: true}, "PARROT0009": {id: "PARROT0009", name: "Dakota", isAvailable: false}};

    resource function post pet(@http:Payload {mediaType: ["application/json"]} Pet payload) returns @http:Payload {mediaType: "application/json+id"} json|http:MethodNotAllowed {
        if (self.petInventory[payload.id] is ()) {
            self.petInventory[payload.id] = payload;
            return <json>payload;
        } else{
            json errorMessage = {"message": "A pet with given pet id " + payload.id + " already exists in the inventory."};
            return errorMessage;
        }
    }

    resource function get pet/[string petId]() returns @http:Payload {mediaType: "application/json+id"} json|http:BadRequest|http:NotFound {
        Pet? pet = self.petInventory[petId];
        if (pet is ()) {
            http:NotFound response = {body: "No pet is listed with the given pet id " + petId};
            return response;
        } else {
            return <json>pet;
        }
    }

}
