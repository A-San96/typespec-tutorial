import "@typespec/http";
import "@typespec/versioning";

using Http;
using Versioning;

@service(#{ title: "Pet Store" })
@server("https://petstore.example.com", "The main server for the Pet Store API")
@versioned(Versions)
namespace PetStore;

enum Versions {
  v1: "1.0.0",
  v2: "2.0.0",
}

model CommonParameters {
  @header
  requestId: string;

  @query
  locale?: string;

  @header
  clientVersion?: string;
}

@added(Versions.v2)
model Toy {
  id: int32;
  name: string;
}

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
