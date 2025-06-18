import "@typespec/http";

using Http;
@service(#{ title: "Pet Store" })
@server("https://petstore.example.com", "The main server for the Pet Store API")
namespace PetStore;

model Pet {
    id: int32;

    @minLength(2)
    name: string;

    @minValue(0)
    @maxValue(100)
    age: int32;

    kind: petType;
}

enum petType {
    dog: "dog",
    cat: "cat",
    fish: "fish",
    bird: "bird",
    reptile: "reptile",
}
