import "@typespec/http";
import "@typespec/versioning";
import "./petstore/models.tsp";
import "./petstore/errors.tsp";
import "./petstore/responses.tsp";

using Http;
using Versioning;

@service(#{ title: "Pet Store" })
@server("https://petstore.example.com", "The main server for the Pet Store API")
@versioned(Versions)
namespace PetStore;

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
