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

model PetListResponse {
  ...OkResponse;
  ...Body<Pet[]>;
}

model PetResponse {
  ...OkResponse;
  ...Body<Pet>;
}

model PetCreatedResponse {
  ...CreatedResponse;
  ...Body<Pet>;
}

model PetErrorResponse {
  ...BadRequestResponse;
  ...Body<ValidationError>;
}

model PetNotFoundResponse {
  ...NotFoundResponse;
  ...Body<NotFoundError>;
}

model PetUnauthorizedResponse {
  ...UnauthorizedResponse;
  ...Body<UnauthorizedError>;
}

model PetSuccessResponse {
  ...OkResponse;
  ...Body<Pet>;
}

model PetNoContentResponse {
  ...NoContentResponse;
}

model InternalServerErrorResponse {
  @statusCode statusCode: 500;
  ...Body<InternalServerError>;
}
@route("/pets")
namespace Pets {
  @get
  op listPets(...CommonParameters): PetListResponse;

  @get
  op getPet(@path petId: int32, ...CommonParameters):
    | PetResponse
    | PetNotFoundResponse
    | PetUnauthorizedResponse
    | PetErrorResponse;

  @useAuth(BearerAuth)
  @post
  op createPet(@body pet: Pet, ...CommonParameters):
    | PetCreatedResponse
    | PetErrorResponse
    | PetUnauthorizedResponse
    | InternalServerErrorResponse;

  @useAuth(BearerAuth)
  @put
  op updatePet(@path petId: int32, @body pet: Pet, ...CommonParameters):
    | PetSuccessResponse
    | PetNotFoundResponse
    | PetErrorResponse
    | PetUnauthorizedResponse
    | InternalServerErrorResponse;

  @useAuth(BearerAuth)
  @delete
  op deletePet(@path petId: int32, ...CommonParameters):
    | PetNoContentResponse
    | PetNotFoundResponse
    | PetUnauthorizedResponse
    | InternalServerErrorResponse;

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
