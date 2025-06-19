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

@error
model NotFoundError {
    code: "NOT_FOUND";
    message: string;
}

@error
model ValidationError {
    code: "VALIDATION_ERROR";
    message: string;
    details: string[];
}

@error
model InternalServerError {
    code: "INTERNAL_SERVER_ERROR";
    message: string;
}

@error
model UnauthorizedError {
    code: "UNAUTHORIZED";
    message: string;
}

model CommonParameters {
    @header
    requestId: string;

    @query
    locale?: string;

    @header
    clientVersion?: string;
}

@route("/pets")
namespace Pets {
    @get
    op listPets(...CommonParameters): {
        @statusCode statusCode: 200;
        @body pets: Pet[];
    };

    @get
    op getPet(@path petId: int32, ...CommonParameters): {
        @statusCode statusCode: 200;
        @body pet: Pet;
    } | {
        @statusCode statusCode: 404;
        @body error: NotFoundError;
    };

    @useAuth(BearerAuth)
    @post
    op createPet(@body pet: Pet, ...CommonParameters):
        | {
              @statusCode statusCode: 201;
              @body newPet: Pet;
          }
        | {
              @statusCode statusCode: 202;
              @body acceptedPet: Pet;
          }
        | {
              @statusCode statusCode: 400;
              @body error: ValidationError;
          }
        | {
              @statusCode statusCode: 401;
              @body error: UnauthorizedError;
          }
        | {
              @statusCode statusCode: 500;
              @body error: InternalServerError;
          };

    @useAuth(BearerAuth)
    @put
    op updatePet(@path petId: int32, @body pet: Pet, ...CommonParameters):
        | {
              @statusCode statusCode: 200;
              @body pet: Pet;
          }
        | {
              @statusCode statusCode: 404;
              @body error: NotFoundError;
          }
        | {
              @statusCode statusCode: 400;
              @body error: ValidationError;
          }
        | {
              @statusCode statusCode: 401;
              @body error: UnauthorizedError;
          }
        | {
              @statusCode statusCode: 500;
              @body error: InternalServerError;
          };

    @useAuth(BearerAuth)
    @delete
    op deletePet(@path petId: int32, ...CommonParameters): {
        @statusCode statusCode: 204;
    } | {
        @statusCode statusCode: 404;
        @body error: NotFoundError;
    } | {
        @statusCode statusCode: 400;
        @body error: UnauthorizedError;
    };

    @route("{petId}/toys")
    namespace Toys {
        @added(Versions.v2)
        @get
        op listToys(@path petId: int32, ...CommonParameters): {
            @statusCode statusCode: 200;
            @body toys: Toy[];
        } | {
            @statusCode statusCode: 404;
            @body error: NotFoundError;
        };

        @added(Versions.v2)
        @useAuth(BearerAuth)
        @post
        op createToy(@path petId: int32, @body toy: Toy, ...CommonParameters):
            | {
                  @statusCode statusCode: 201;
                  @body newToy: Toy;
              }
            | {
                  @statusCode statusCode: 400;
                  @body error: ValidationError;
              }
            | {
                  @statusCode statusCode: 401;
                  @body error: UnauthorizedError;
              }
            | {
                  @statusCode statusCode: 500;
                  @body error: InternalServerError;
              };

        @added(Versions.v2)
        @useAuth(BearerAuth)
        @put
        op updateToy(
            @path petId: int32,
            @path toyId: int32,
            @body toy: Toy,
            ...CommonParameters,
        ):
            | {
                  @statusCode statusCode: 200;
                  @body toy: Toy;
              }
            | {
                  @statusCode statusCode: 404;
                  @body error: NotFoundError;
              }
            | {
                  @statusCode statusCode: 400;
                  @body error: ValidationError;
              }
            | {
                  @statusCode statusCode: 401;
                  @body error: UnauthorizedError;
              }
            | {
                  @statusCode statusCode: 500;
                  @body error: InternalServerError;
              };
    }
}
