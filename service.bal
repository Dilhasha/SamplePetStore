import ballerina/http;

type Pet record {
    string id;
    string name;
    boolean isAvailable;
};

map<Pet> petInventory = {"DOG0020": {id: "DOG0020", name: "Snowy", isAvailable: true}, "CAT3400": {id: "CAT3400", name: "Kygo", isAvailable: true}, "PARROT0009": {id: "PARROT0009", name: "Dakota", isAvailable: false}};

service / on new http:Listener(9090) {
    resource function get pet(http:Caller caller, http:Request request) {
        http:Response response = new;
        string? petId = request.getQueryParamValue("id");
        if (petId is string) {
            Pet? pet = petInventory[petId];
            if (!(pet is ())) {
                //json petDetails = {"id": pet.id, "name": pet.name, "isAvailable": pet.isAvailable.toString()};
                response.statusCode = 200;
                response.setJsonPayload(<json>pet);
            } else {
                response.statusCode = 200;
                response.setPayload("No pet is listed with the given pet id " + petId);
            }
        } else {
            response.statusCode = 500;
            response.setPayload("The pet id is not provided.");
        }
        checkpanic caller->respond(response);
    }

    resource function post addPet(http:Caller caller, http:Request request) returns error? {
        //get json payload and create record 
        http:Response response = new;
        var petDetails = request.getJsonPayload();
        if (petDetails is json) {
            json petId = check petDetails.Pet.id;
            json petName = check petDetails.Pet.name;
            json isAvailable = check petDetails.Pet.isAvailable;
            if (isAvailable.toString() != "true" && isAvailable.toString() != "false") {
                response.statusCode = 500;
                response.setPayload("The flag 'isAvailable' needs to be a boolean value.");
                checkpanic caller->respond(response);
            } else {
                petInventory[petId.toString()] = {id: petId.toString(), name: petName.toString(), isAvailable: isAvailable.toString() == "true"};
                response.statusCode = 200;
                response.setPayload("The pet '" + petId.toString() + "' was successfully added to the inventory.");
                checkpanic caller->respond(response);
            }
        } else {
            response.statusCode = 500;
            response.setPayload(petDetails.message());
            checkpanic caller->respond(response);
        }
    }

}

